"""Write prog_pkg.vhdl: the program the Basys 3 build starts with (in the emulated flash and RAM A).

  python mkprog.py                  the demo below
  python mkprog.py out.bin          raw little-endian binary, e.g. from assemble.sh / the linker
  python mkprog.py prog.hex         one 32-bit word per line, like test/prog.hex
  python mkprog.py --test NAME      a test program from test/programs.py (ends with 0xA5 on the LEDs)

Then rebuild the bitstream in Vivado.
"""

import os
import struct
import sys

here = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(here, "..", "..", "test"))
from cupu import GPIN, GPIO, I, JRAL, LB, Prog, R, SB, SW  # noqa: E402

ANDI, ADDI = 0x0D, 0x08
OR, SHL, MUL, DIV, REM, NEQ, LT = 0x04, 0x08, 0x02, 0x03, 0x0A, 0x21, 0x24
ITOF, FTOI, FADD, FSUB, FMUL, FDIV, SQRT, SIN, COS, TAN = range(0x0E, 0x18)


def f2b(x):
    return struct.unpack("<I", struct.pack("<f", x))[0]


DISPLAY = 0x00FFFC   # basys3_top shows the word stored here on the 7-segment display

# switch -> (what it computes, the 7-segment display, the LEDs: the result rounded)
TESTS = {
    1: ("100 * sin(128)    sin, with the large-argument reduction", "72.10", 0x48),
    2: ("100 * cos(1)      cos", "54.03", 0x36),
    3: ("10 * tan(1)       tan", "15.57", 0x10),
    4: ("sqrt(100 + 44)    fadd, sqrt", "12.00", 0x0C),
    5: ("1000 / 7          itof, fdiv", "142.9", 0x8F),
    6: ("12.5 * 3 - 0.25   fmul, fsub", "37.25", 0x25),
    7: ("120 * 50 / 47     integer mul, div", "127", 0x7F),
}


def demo(delay):
    """SW0 on: a counter, about 5 steps a second.
    Otherwise the lowest switch of SW1..SW7 that is on picks a fixed calculation (see TESTS),
    computed again every loop; all off shows 0.
    The LEDs (uo_out) get the result rounded to an integer. For the 7-segment display the
    program itself turns the result into 4 significant decimal digits and the position of the
    decimal point, and stores them at DISPLAY: digits in bits 15..0 (4 bits each, the leftmost
    digit in 15..12), the number of digits after the point in bits 17..16.
    Only relative jumps, so it runs from the flash (SW0 on at reset) as well as from RAM."""
    p = Prog("demo")
    p.li(20, GPIO)
    p.li(21, GPIN)
    p.li(8, f2b(100.0))
    p.li(9, f2b(128.0))
    p.li(10, f2b(1.0))
    p.li(11, f2b(10.0))
    p.li(12, f2b(44.0))
    p.li(13, 1000)
    p.li(14, 7)
    p.li(15, f2b(12.5))
    p.li(16, f2b(3.0))
    p.li(17, f2b(0.25))
    p.li(18, 120)
    p.li(19, 50)
    p.li(22, 47)
    p.li(2, DISPLAY)
    p.li(27, f2b(1000.0))
    p.li(30, 10)
    p.li(31, 4)
    p.li(23, 16)
    p.li(1, 0)

    def when(sw):                             # following instructions with cond=1 need SW<sw>
        p.emit(I(ANDI, 4, 3, 1 << sw))
        p.emit(R(0, 4, 0, NEQ))

    loop = p.pc()
    p.emit(R(3, 21, 0, LB))                   # r3 = switches
    p.emit(I(ADDI, 1, 1, 1))                  # counter
    p.emit(I(ADDI, 5, 0, 0))                  # nothing selected: 0
    p.emit(I(ADDI, 24, 0, 0))                 # r24 = value for the display (float), 0.0
    p.emit(I(ADDI, 25, 0, 0))                 # r25 = digits after the point, at most
    when(7)                                   # lower switches come later and win
    p.emit(R(6, 18, 19, MUL, cond=1))
    p.emit(R(5, 6, 22, DIV, cond=1))
    p.emit(R(24, 5, 0, ITOF, cond=1))         # an integer: no digits after the point
    when(6)
    p.emit(R(6, 15, 16, FMUL, cond=1))
    p.emit(R(6, 6, 17, FSUB, cond=1))
    p.emit(R(5, 6, 0, FTOI, cond=1))
    p.emit(I(ADDI, 24, 6, 0, cond=1))
    p.emit(I(ADDI, 25, 0, 3, cond=1))
    when(5)
    p.emit(R(6, 13, 0, ITOF, cond=1))
    p.emit(R(7, 14, 0, ITOF, cond=1))
    p.emit(R(6, 6, 7, FDIV, cond=1))
    p.emit(R(5, 6, 0, FTOI, cond=1))
    p.emit(I(ADDI, 24, 6, 0, cond=1))
    p.emit(I(ADDI, 25, 0, 3, cond=1))
    when(4)
    p.emit(R(6, 8, 12, FADD, cond=1))
    p.emit(R(6, 6, 0, SQRT, cond=1))
    p.emit(R(5, 6, 0, FTOI, cond=1))
    p.emit(I(ADDI, 24, 6, 0, cond=1))
    p.emit(I(ADDI, 25, 0, 3, cond=1))
    when(3)
    p.emit(R(6, 10, 0, TAN, cond=1))
    p.emit(R(6, 6, 11, FMUL, cond=1))
    p.emit(R(5, 6, 0, FTOI, cond=1))
    p.emit(I(ADDI, 24, 6, 0, cond=1))
    p.emit(I(ADDI, 25, 0, 3, cond=1))
    when(2)
    p.emit(R(6, 10, 0, COS, cond=1))
    p.emit(R(6, 6, 8, FMUL, cond=1))
    p.emit(R(5, 6, 0, FTOI, cond=1))
    p.emit(I(ADDI, 24, 6, 0, cond=1))
    p.emit(I(ADDI, 25, 0, 3, cond=1))
    when(1)
    p.emit(R(6, 9, 0, SIN, cond=1))
    p.emit(R(6, 6, 8, FMUL, cond=1))
    p.emit(R(5, 6, 0, FTOI, cond=1))
    p.emit(I(ADDI, 24, 6, 0, cond=1))
    p.emit(I(ADDI, 25, 0, 3, cond=1))
    when(0)
    p.emit(I(ADDI, 5, 1, 0, cond=1))          # SW0: the counter
    p.emit(I(ANDI, 6, 1, 255, cond=1))
    p.emit(R(24, 6, 0, ITOF, cond=1))
    p.emit(I(ADDI, 25, 0, 0, cond=1))
    p.emit(R(5, 20, 0, SB))                   # uo_out = r5

    # display: scale r24 by 10 until it has 4 digits before the point (or r25 digits after it);
    # comparing the bits works because the value is not negative
    p.emit(I(ADDI, 26, 0, 0))                 # r26 = digits after the point
    scale = p.pc()
    p.emit(R(0, 24, 27, LT))                  # value < 1000.0
    p.emit(R(0, 26, 25, LT, cond=1))          # and r26 < r25
    p.emit(R(24, 24, 11, FMUL, cond=1))
    p.emit(I(ADDI, 26, 26, 1, cond=1))
    p.emit(I(JRAL, 0, 0, scale - p.pc(), cond=1))
    p.emit(R(28, 24, 0, FTOI))                # 0..9999
    p.emit(R(29, 28, 30, REM))                # digit 0 (rightmost)
    p.emit(R(28, 28, 30, DIV))
    p.emit(R(7, 28, 30, REM))                 # digit 1
    p.emit(R(28, 28, 30, DIV))
    p.emit(R(6, 28, 30, REM))                 # digit 2
    p.emit(R(28, 28, 30, DIV))                # r28 = digit 3
    p.emit(R(4, 28, 31, SHL))
    p.emit(R(4, 4, 6, OR))
    p.emit(R(4, 4, 31, SHL))
    p.emit(R(4, 4, 7, OR))
    p.emit(R(4, 4, 31, SHL))
    p.emit(R(4, 4, 29, OR))
    p.emit(R(26, 26, 23, SHL))
    p.emit(R(4, 4, 26, OR))
    p.emit(R(4, 2, 0, SW))                    # mem[DISPLAY] = digits
    p.li(7, delay)
    wait = p.pc()
    p.emit(I(ADDI, 7, 7, -1))
    p.emit(R(0, 7, 0, 0x21))
    p.emit(I(JRAL, 0, 0, wait - p.pc(), cond=1))
    p.emit(I(JRAL, 0, 0, loop - p.pc()))
    return p.words


def load(path):
    data = open(path, "rb").read()
    if path.endswith(".bin"):
        data += b"\0" * (-len(data) % 4)
        return list(struct.unpack(f"<{len(data) // 4}I", data))
    return [int(w, 16) for line in data.decode().splitlines() for w in line.split("//")[0].split()]


def main():
    args = sys.argv[1:]
    if not args:
        words, src = demo(8000), "the demo"
    elif args[0] == "--demo":                 # --demo N: shorter delay, for simulation
        words, src = demo(int(args[1])), f"the demo (delay {args[1]})"
    elif args[0] == "--test":
        import programs
        words, src = programs.build(args[1], quick=True).words, f"test program {args[1]}"
    else:
        words, src = load(args[0]), os.path.basename(args[0])

    out = [f"-- Generated by mkprog.py from {src}, do not edit.",
           "library ieee;",
           "use ieee.std_logic_1164.all;",
           "",
           "package prog_pkg is",
           "  type word_array is array (natural range <>) of std_logic_vector(31 downto 0);",
           f"  constant PROG : word_array(0 to {len(words) - 1}) := ("]
    out += [f'    {i} => x"{w:08x}"{"," if i < len(words) - 1 else ""}' for i, w in enumerate(words)]
    out += ["  );", "end package;", ""]
    with open(os.path.join(here, "prog_pkg.vhdl"), "w", newline="\n") as f:
        f.write("\n".join(out))
    print(f"prog_pkg.vhdl: {len(words)} words from {src}")


if __name__ == "__main__":
    main()
