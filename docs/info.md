<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A multi-cycle implementation of the full CUPU-II "Stollentroll" ISA (`isa.txt`): 32-bit, 32 registers
($0 is zero), one condition flag, conditional execution via bit 31, integer and floating point ops.

Program and data live on the Tiny Tapeout QSPI Pmod, accessed in plain SPI mode at clk/2:

- the two PSRAMs: 0x000000–0x7FFFFF is RAM A, 0x800000–0xFFFFFF RAM B, matching the emulator's
  16 MiB;
- the flash, read only, at 0x01000000–0x01FFFFFF. Code runs straight from it (execute in place)
  and loads read from it; stores to it are ignored, so a program can never erase or overwrite it.

After reset the registers are cleared and execution starts at address 0 (PSRAM), or at 0x01000000
(flash) if `ui_in[0]` was high while `rst_n` was low.

The design is built to route in GF180 with its three routing layers, so it avoids wide
multiplexers:

- The register file is bit-serial: each register is a ring of 32 flip-flops rotating one bit per
  clock. Reading `$a` and `$b` takes 32 cycles; writing `$t` takes 32 cycles in the background while
  the next instruction is fetched.
- The integer core is bit-serial too: all integer arithmetic goes through one 1-bit adder. The
  operands stream out of the register rings in one 32-cycle pass, and add, sub, the logic ops,
  compares, `lui` and jump targets are computed on the way. `mul`/`mhi` and `div`/`rem` take one
  33-cycle pass per bit (about 1,100 cycles), shifts one cycle per bit.
- An instruction takes about 185 cycles, most of it the SPI fetch (~110k instructions/s at 20 MHz).

The FPU implements all ten float ops (`itof`, `ftoi`, `fadd`, `fsub`, `fmul`, `fdiv`, `sqrt`, `sin`,
`cos`, `tan`) on IEEE 754 binary32 with round to nearest even, subnormals included. It is
bit-serial as well: its working values circulate in 66-bit shift rings through a one-bit adder, one
66-cycle pass per step. `sin`/`cos`/`tan` use Payne-Hanek argument reduction and a 62-step CORDIC
(three passes per step, about 12,000 cycles).

### Memory map

| Address      | Access | Device                                                      |
|--------------|--------|-------------------------------------------------------------|
| 0x00000000   | r/w    | PSRAM, 16 MiB                                               |
| 0x01000000   | r      | SPI flash, 16 MiB (stores are ignored)                      |
| 0x20000000   | r/w    | seconds counter (32 bit); a word store sets it, e.g. to unix time |
| 0x20000004   | r      | GPIO inputs: the `ui_in` pins (never waits)                 |
| 0x20000008   | r/w    | GPIO outputs: drives `uo_out`, reads back the last value written |

### GPIO

There are 8 inputs (`ui_in`) and 8 outputs (`uo_out`); on Tiny Tapeout their direction is fixed.
A load from 0x20000004 returns the input pins as they were two clocks earlier (they pass through a
synchronizer); a store to 0x20000008 sets the output pins. Each takes one instruction, so software
can sample or toggle a pin roughly every 10 µs.

For a bidirectional open-drain line (I²C, 1-Wire, a shared bus), pair an output with an input:
put a diode from the line to the output pin (cathode at the output), a pull-up resistor on the
line, and wire the input pin to the line. Writing 0 pulls the line low, writing 1 releases it, and
the input reads what is on the line.

### Behaviour where isa.txt is silent or differs from the Go emulator

- Stores write `$t` to `mem[$a]`, like the emulator (isa.txt says `$b`).
- `ovrf`/`unrf` copy the emulator, which passes carry-in 1 to `bits.Add32`/`Sub32`:
  `ovrf` = carry of `a+b+1`, `unrf` = `a <= b` (unsigned). This is probably an emulator bug.
- `uaddi` … `uxori` zero-extend the immediate. The emulator gets `umuli`/`udivi` wrong because Go
  parses `a*Imm&0xFFFF` as `(a*Imm)&0xFFFF`.
- `divi` is signed (the emulator divides unsigned by the sign-extended immediate).
- `jal`/`jral` read `$a` before writing `$t`; the emulator writes first (differs when `$t == $a`).
- Integer division by zero halts the CPU (the emulator panics).
- `ftoi` rounds half away from zero like Go's `math.Round`; NaN, infinities and out-of-range values
  give 0x80000000. Every NaN result is 0x7FC00000.
- `sin`/`cos`/`tan` are within 1 ulp of Go's `float32(math.Sin(float64(x)))`; in testing they matched
  exactly.
- There is no keyboard: 0x20000004 returns the `ui_in` pins at once instead of waiting for a key.
- Comparisons are unsigned, as in the emulator.

## How to test

1. Hold `rst_n` low. All `uio` pins are inputs then, so the RP2040 on the demo board can write a
   program (little-endian 32-bit words) into RAM A, or program it into the flash, through the Pmod.
   A program in the flash stays there across power cycles.
2. Set `ui_in[0]` to choose where to start: low runs from RAM A (address 0), high runs straight
   from the flash (address 0x01000000). It is sampled while `rst_n` is low.
3. Release reset. The CPU clears its registers and starts fetching. A program that runs from the
   flash must be linked for 0x01000000 (`jal` targets are absolute) and keeps its writable data in
   the PSRAM.
4. Drive the inputs (the demo board's DIP switches or its RP2040 on `ui_in`) and watch `uo_out`,
   for example on the demo board's 7-segment display.

`test/` runs one small self-checking program per feature, including booting from the flash
(cocotb + Icarus, `make` in `test/`; `python programs.py --list` lists them).
`test/vhdl/run.sh` runs the same programs, and a stand-alone FPU vector test (`run.sh fpu`), on the
VHDL with GHDL.

## External hardware

Tiny Tapeout QSPI Pmod (W25Q128 flash + 2x APS6404L PSRAM) on the bidirectional header. All three
chips are used in plain SPI mode with the 0x03 read command and a 24-bit address, so any flash that
supports that works. After reset the design drives SD2/SD3 high (the flash's `/WP` and `/HOLD`), and
the flash must be left in its normal state by whatever programmed it (not powered down, not in a
continuous-read or QPI mode).
