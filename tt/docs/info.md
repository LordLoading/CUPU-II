## How it works

A multi-cycle implementation of the CUPU-II "Stollentroll" ISA (`isa.txt`): 32-bit, 32 registers
($0 is zero), one condition flag, conditional execution via bit 31.

Program and data live in the two PSRAMs of the Tiny Tapeout QSPI Pmod, accessed in plain SPI
mode at clk/2. Addresses 0x000000–0x7FFFFF go to RAM A, 0x800000–0xFFFFFF to RAM B, matching
the emulator's 16 MiB. Execution starts at address 0 after reset.

To save area the core has a single register-file read port, one shared 33-bit adder, a 32-cycle
iterative multiplier/divider and a one-bit-per-cycle shifter. An instruction takes about 134
cycles, almost all of it the SPI fetch (~185k instructions/s at 25 MHz; mul/div add 32 cycles).

### Memory map

| Address      | Access | Device                                      |
|--------------|--------|---------------------------------------------|
| 0x00000000   | r/w    | PSRAM, 16 MiB                               |
| 0x20000000   | r      | seconds since reset (32 bit)                |
| 0x20000004   | r      | keyboard: current value of `ui_in`          |
| 0x20000008   | r/w    | GPIO: drives `uo_out`                       |

### Differences from isa.txt / the Go emulator

- **FPU ops (`itof` … `tan`) are not implemented** and write 0 to `$t`. They would not fit.
- Stores write `$t` to `mem[$a]`, like the emulator (isa.txt says `$b`).
- `ovrf`/`unrf` copy the emulator, which passes carry-in 1 to `bits.Add32`/`Sub32`:
  `ovrf` = carry of `a+b+1`, `unrf` = `a <= b` (unsigned). This is probably an emulator bug.
- `uaddi` … `uxori` zero-extend the immediate. The emulator gets `umuli`/`udivi` wrong because
  Go parses `a*Imm&0xFFFF` as `(a*Imm)&0xFFFF`.
- `divi` is signed (the emulator divides unsigned by the sign-extended immediate).
- `jal`/`jral` read `$a` before writing `$t`; the emulator writes first (differs when `$t == $a`).
- Division by zero gives an undefined result (the emulator panics).
- Registers are not cleared on reset.
- The timestamp counts seconds since reset, and the keyboard read never blocks.
- Comparisons are unsigned, as in the emulator.

## How to test

1. Hold `rst_n` low. All `uio` pins are inputs, so the RP2040 on the demo board can write a
   program into RAM A through the Pmod.
2. Release reset. The CPU fetches from address 0.
3. Watch `uo_out`, which the program drives by writing to 0x20000008.

Simulation: `test/run.sh` builds a program that checks every instruction against a Python
reference model and runs it on the VHDL with GHDL.

## External hardware

Tiny Tapeout QSPI Pmod (W25Q128 flash + 2x APS6404L PSRAM) on the bidirectional header.
The flash is not used and its CS is held high.
