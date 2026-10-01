# CUPU-II "Stollentroll" 
A simple risc type CPU

This project is subdivided into smaller sub-projects:

| Project | Language | Location |
|-----------|----------|----------|
| Assembler | Zig | `asm/` |
| Linker | D | `lnk/` |
| Emulator | Go | `emu/` |
| Logisim-Evo | Logisim | `planned but not started` |


## ISA
32 general-purpose registers (`$0`-`$31`; `$0` is always zero). 

Two instruction formats:
- **R-type**: `opcode`, `target`, `a`, `b`, `func11`
- **I-type**: `opcode`, `target`, `a`, `immediate`

Conditional bit: when set, the instruction only executes if the condition flag is set.

For more details, see [`isa.txt`](isa.txt)

## Build
To fully use this Project, you will need to build the assembler, linker, and emulator.
To do that you will need zig, d, and golang. (sorry, i just wanted to try stuff out)

```bash
# build assembler
cd asm && zig build

# build linker
cd lnk && dub build

# build emulator
cd emu && go build ./
```

## Usage
with `assemble.sh` on unix-like systems or `assemble.ps1` on windows and a path to a dir you provide you can assemble and link all .asm files and in that path.
example: `sh assemble.sh prog/test`

you can then run it by going to `./emu` and running `go run . -bin out/out.bin`
