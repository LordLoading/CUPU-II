"""Generate a CUPU-II test program and the results a correct CPU must store.

Every test leaves one word in the result area at 0x100000. At the end the program
writes 0xA5 to gpio, divides by zero (which must halt the CPU) and would write 0xEE
to gpio if it kept running.

Keyboard protocol the testbench has to follow:
  - right after reset, strobe KEY1 (ui_in(7) rising edge, character on ui_in(6:0))
  - when gpio reads WAIT_KEY, the program is blocked on the keyboard: strobe KEY2

expected.txt has one line per result: the value, and -1 for an exact compare or the
FPU op number (fpu_ref.matches decides what counts as equal).
"""

import os
import random
import sys

sys.path.insert(0, os.path.dirname(__file__))
from fpu_ref import f2b, fpu  # noqa: E402

M = 0xFFFFFFFF
RES = 0x100000
KEY1 = 0x5A      # 'Z'
KEY2 = 0x71      # 'q'
WAIT_KEY = 0x3C
DONE = 0xA5
FAIL = 0xEE


def s32(x):
    x &= M
    return x - (1 << 32) if x & 0x80000000 else x


def sext16(x):
    x &= 0xFFFF
    return x - 0x10000 if x & 0x8000 else x


def tdiv(a, b):
    q = abs(a) // abs(b)
    return q if (a < 0) == (b < 0) else -q


# reference semantics, per isa.txt (emulator behaviour where the spec is silent)
R_OPS = {
    0x00: lambda a, b: a + b,
    0x01: lambda a, b: a - b,
    0x02: lambda a, b: s32(a) * s32(b),
    0x03: lambda a, b: tdiv(s32(a), s32(b)),
    0x04: lambda a, b: a | b,
    0x05: lambda a, b: a & b,
    0x06: lambda a, b: a ^ b,
    0x07: lambda a, b: ~a,
    0x08: lambda a, b: a << b if b < 32 else 0,
    0x09: lambda a, b: a >> b if b < 32 else 0,
    0x0A: lambda a, b: s32(a) - tdiv(s32(a), s32(b)) * s32(b),
    0x0B: lambda a, b: (s32(a) * s32(b)) >> 32,
    0x0C: lambda a, b: int(a + b + 1 > M),
    0x0D: lambda a, b: int(a <= b),
}
CMP_OPS = {
    0x20: lambda a, b: a == b,
    0x21: lambda a, b: a != b,
    0x22: lambda a, b: a > b,
    0x23: lambda a, b: a >= b,
    0x24: lambda a, b: a < b,
    0x25: lambda a, b: a <= b,
}
I_OPS = {
    0x08: lambda a, i: a + sext16(i),
    0x09: lambda a, i: a - sext16(i),
    0x0A: lambda a, i: s32(a) * sext16(i),
    0x0B: lambda a, i: tdiv(s32(a), sext16(i)),
    0x0C: lambda a, i: a | (sext16(i) & M),
    0x0D: lambda a, i: a & (sext16(i) & M),
    0x0E: lambda a, i: a ^ (sext16(i) & M),
    0x18: lambda a, i: a + i,
    0x19: lambda a, i: a - i,
    0x1A: lambda a, i: a * i,
    0x1B: lambda a, i: a // i,
    0x1C: lambda a, i: a | i,
    0x1D: lambda a, i: a & i,
    0x1E: lambda a, i: a ^ i,
}
FLOATS = [0x00000000, 0x80000000, 0x3F800000, 0xBF800000, 0x7F800000, 0xFF800000, 0x7FC00000,
          0x00000001, 0x007FFFFF, 0x7F7FFFFF, 0x40490FDB, 0x3FC90FDB, 0x4F000000, 0xCF000000]


def R(t, a, b, fn, cond=0):
    return (cond << 31) | (t << 21) | (a << 16) | (b << 11) | fn


def I(opc, t, a, imm, cond=0):
    return (cond << 31) | (opc << 26) | (t << 21) | (a << 16) | (imm & 0xFFFF)


class Prog:
    def __init__(self):
        self.words = []
        self.expected = []

    def emit(self, w):
        self.words.append(w & M)

    def pc(self):
        return 4 * len(self.words)

    def li(self, r, v):
        self.emit(I(0x0F, r, 0, (v >> 16) & 0xFFFF))  # lui
        self.emit(I(0x1C, r, r, v & 0xFFFF))          # uori

    def store_result(self, r, value, kind=-1):
        self.emit(R(r, 10, 0, 0x33))   # sw r -> mem[r10]
        self.emit(I(0x08, 10, 10, 4))  # addi r10, r10, 4
        self.expected.append((value & M, kind))

    def gpio(self, v):
        self.li(20, 0x20000008)
        self.li(21, v)
        self.emit(R(21, 20, 0, 0x35))  # sb


def build(seed=1, quick=False):
    """quick: a small subset for slow (gate level) simulation."""
    rnd = random.Random(seed)
    p = Prog()
    p.li(10, RES)

    # registers are zero after reset
    for r in (1, 29, 31):
        p.store_result(r, 0)

    edge = [0, 1, 2, 31, 32, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0xFFFFFFFE, 12345, 0xDEADBEEF]
    if quick:
        edge = [1, 31, 0x80000000, 0xFFFFFFFF, 0xDEADBEEF]
    pairs = [(a, b) for a in edge for b in edge[:6]]
    pairs += [(rnd.getrandbits(32), rnd.getrandbits(32)) for _ in range(2 if quick else 6)]
    pairs += [(rnd.getrandbits(32), rnd.randrange(40)) for _ in range(2 if quick else 4)]

    for fn, f in R_OPS.items():
        for a, b in pairs:
            if fn in (0x03, 0x0A) and b == 0:
                continue  # division by zero halts, tested at the end
            p.li(1, a)
            p.li(2, b)
            p.emit(R(3, 1, 2, fn))
            p.store_result(3, f(a, b))

    for fn, f in CMP_OPS.items():
        for a, b in pairs[: 6 if quick else 20]:
            p.li(1, a)
            p.li(2, b)
            p.emit(I(0x08, 3, 0, 7))              # addi r3, $z, 7
            p.emit(R(0, 1, 2, fn))                # compare -> flag
            p.emit(I(0x08, 3, 0, 1, cond=1))      # if flag: addi r3, $z, 1
            p.store_result(3, 1 if f(a, b) else 7)

    imms = [1, 0x8000, 0xFFFF, 0x1234] if quick else [0, 1, 3, 0x7FFF, 0x8000, 0xFFFF, 0x1234, 0xFFFE]
    for opc, f in I_OPS.items():
        for a in edge[:8] + [rnd.getrandbits(32)]:
            for imm in imms:
                if opc in (0x0B, 0x1B) and imm == 0:
                    continue
                p.li(1, a)
                p.emit(I(opc, 3, 1, imm))
                p.store_result(3, f(a, imm))

    # floating point, func 0x0E..0x17
    fl = FLOATS[:6] if quick else FLOATS
    for op in range(10):
        cases = [(a, b) for a in fl for b in fl[:3 if quick else 5]]
        for _ in range(4 if quick else 25):
            if op <= 1:
                a = rnd.choice([rnd.getrandbits(32), rnd.randrange(-100, 100) & M, f2b(rnd.randrange(-50, 50) + 0.5)])
            elif op >= 7:
                a = f2b(rnd.uniform(-1e4, 1e4)) if rnd.random() < 0.7 else rnd.getrandbits(32)
            else:
                a = rnd.getrandbits(32) if rnd.random() < 0.5 else f2b(rnd.uniform(-100, 100))
            cases.append((a, f2b(rnd.uniform(-100, 100)) if rnd.random() < 0.5 else rnd.getrandbits(32)))
        for a, b in cases:
            p.li(1, a)
            p.li(2, b)
            p.emit(R(3, 1, 2, 0x0E + op))
            p.store_result(3, fpu(op, a, b), op)

    # lui alone
    p.emit(I(0x0F, 3, 0, 0xBEEF))
    p.store_result(3, 0xBEEF0000)

    # writing $z has no effect
    p.emit(I(0x08, 0, 0, 55))
    p.store_result(0, 0)

    # jal: absolute jump, link = pc + 4
    p.li(5, 0)
    at = p.pc() + 8
    p.li(7, at + 12 - 0x10)
    p.emit(I(0x10, 4, 7, 0x10))      # jal r4, r7, 0x10 -> at + 12
    p.emit(I(0x08, 5, 0, 99))        # skipped
    p.emit(I(0x08, 5, 0, 98))        # skipped
    p.emit(I(0x08, 5, 5, 1))         # target: r5 += 1
    p.store_result(4, at + 4)
    p.store_result(5, 1)

    # jral: pc = pc + imm + $a
    p.li(6, 4)
    at = p.pc()
    p.emit(I(0x11, 4, 6, 8))         # jral r4, r6, 8 -> at + 12
    p.emit(I(0x08, 5, 0, 99))
    p.emit(I(0x08, 5, 0, 98))
    p.emit(I(0x08, 5, 5, 1))
    p.store_result(4, at + 4)
    p.store_result(5, 2)

    # skipped conditional does not change flag or registers
    p.li(1, 5)
    p.emit(R(0, 1, 1, 0x21))         # neq -> flag = 0
    p.emit(I(0x08, 1, 0, 77, cond=1))
    p.store_result(1, 5)

    # memory, including RAM B (addr bit 23) and sub-word accesses
    for base in (0x2000, 0x800100):
        p.li(20, base)
        p.li(21, 0x11223344)
        p.emit(R(21, 20, 0, 0x33))                 # sw
        p.emit(R(3, 20, 0, 0x30))                  # lw
        p.store_result(3, 0x11223344)
        p.emit(I(0x08, 22, 20, 1))
        p.emit(R(3, 22, 0, 0x32))                  # lb +1
        p.store_result(3, 0x33)
        p.emit(I(0x08, 22, 20, 2))
        p.emit(R(3, 22, 0, 0x31))                  # lh +2
        p.store_result(3, 0x1122)
        p.li(21, 0xCAFEF0AB)
        p.emit(R(21, 22, 0, 0x35))                 # sb +2
        p.emit(R(3, 20, 0, 0x30))
        p.store_result(3, 0x11AB3344)
        p.emit(R(21, 20, 0, 0x34))                 # sh +0
        p.emit(R(3, 20, 0, 0x30))
        p.store_result(3, 0x11ABF0AB)

    # the RAM A copy must be untouched by the RAM B writes
    p.li(20, 0x2000)
    p.emit(R(3, 20, 0, 0x30))
    p.store_result(3, 0x11ABF0AB)

    # timestamp: settable, reads back (no full second passes in simulation)
    p.li(20, 0x20000000)
    p.li(21, 1700000000)
    p.emit(R(21, 20, 0, 0x33))
    p.emit(R(3, 20, 0, 0x30))
    p.store_result(3, 1700000000)
    p.emit(I(0x08, 22, 20, 3))
    p.emit(R(3, 22, 0, 0x32))                      # lb, top byte
    p.store_result(3, 1700000000 >> 24)

    # keyboard: KEY1 was strobed long ago and is waiting
    p.li(20, 0x20000004)
    p.emit(R(3, 20, 0, 0x32))
    p.store_result(3, KEY1)

    # gpio readback, which also tells the testbench to send KEY2
    p.gpio(WAIT_KEY)
    p.emit(R(3, 20, 0, 0x32))
    p.store_result(3, WAIT_KEY)

    # this read blocks until KEY2 arrives
    p.li(20, 0x20000004)
    p.emit(R(3, 20, 0, 0x30))                      # lw covering the keyboard byte
    p.store_result(3, KEY2)

    # done; divide by zero must halt
    p.gpio(DONE)
    p.li(1, 7)
    p.emit(R(3, 1, 0, 0x03))
    p.gpio(FAIL)
    p.emit(R(0, 0, 0, 0x40))
    return p


def write_files(p, where="."):
    assert 4 * len(p.words) < RES, "program overlaps result area"
    with open(os.path.join(where, "prog.hex"), "w") as f:
        f.writelines(f"{w:08x}\n" for w in p.words)
    with open(os.path.join(where, "expected.txt"), "w") as f:
        f.writelines(f"{v:08x} {k}\n" for v, k in p.expected)


if __name__ == "__main__":
    prog = build(int(sys.argv[1]) if len(sys.argv) > 1 else 1, quick="quick" in sys.argv)
    write_files(prog)
    print(f"{len(prog.words)} instructions, {len(prog.expected)} results")
