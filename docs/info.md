<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A multi-cycle implementation of the full CUPU-II "Stollentroll" ISA (`isa.txt`): 32-bit, 32 registers
($0 is zero), one condition flag, conditional execution via bit 31, integer and floating point ops.

Program and data live in the two PSRAMs of the Tiny Tapeout QSPI Pmod, accessed in plain SPI mode at
clk/2. Addresses 0x000000–0x7FFFFF go to RAM A, 0x800000–0xFFFFFF to RAM B, matching the emulator's
16 MiB. After reset the registers are cleared and execution starts at address 0.

The integer core has one register-file read port, one shared 33-bit adder, a 32-cycle
multiplier/divider and a one-bit-per-cycle shifter. An instruction takes about 130 cycles, almost all
of it the SPI fetch (~190k instructions/s at 25 MHz).

The FPU implements all ten float ops (`itof`, `ftoi`, `fadd`, `fsub`, `fmul`, `fdiv`, `sqrt`, `sin`,
`cos`, `tan`) on IEEE 754 binary32 with round to nearest even, subnormals included, around one shared
67-bit adder. `sin`/`cos`/`tan` use Payne-Hanek argument reduction and a 62-step CORDIC and
take about 650 cycles.

### Memory map

| Address      | Access | Device                                                      |
|--------------|--------|-------------------------------------------------------------|
| 0x00000000   | r/w    | PSRAM, 16 MiB                                               |
| 0x20000000   | r/w    | seconds counter (32 bit); a word store sets it, e.g. to unix time |
| 0x20000004   | r      | keyboard: blocks until a key arrives, then returns it       |
| 0x20000008   | r/w    | GPIO: drives `uo_out`                                       |

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
- The keyboard holds one key; a second key before the first is read replaces it (the emulator
  buffers 32).
- Comparisons are unsigned, as in the emulator.

## How to test

1. Hold `rst_n` low. All `uio` pins are inputs then, so the RP2040 on the demo board can write a
   program (little-endian 32-bit words) into RAM A through the Pmod.
2. Release reset. The CPU clears its registers and fetches from address 0.
3. Type: put a 7-bit character on `ui_in[6:0]`, then raise `ui_in[7]`. Lower it again before the next key.
4. Watch `uo_out`, which the program drives by writing to 0x20000008.

`test/` runs a self-checking program covering every instruction (cocotb + Icarus, `make` in `test/`).
`test/vhdl/run.sh` runs the same program, and a stand-alone FPU vector test (`run.sh fpu`), on the VHDL
with GHDL.

## External hardware

Tiny Tapeout QSPI Pmod (W25Q128 flash + 2x APS6404L PSRAM) on the bidirectional header. The flash is
not used and its CS is held high.
