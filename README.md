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

use the build script
```bash
# on linux
sh build.sh
# on windows
build.ps1
```

or do it manually
```bash
# build assembler
cd asm && zig build

# build linker
cd lnk && dub build

# build emulator
cd emu && go build ./

# or use the build script in ./
```

## Usage
use the run script
```bash
# on linux
sh run.sh
# on windows
run.ps1
```

or assemble and link without running the emulator
```bash
# on linux
sh assemble.sh prog/test
# on windows
assemble.ps1 prog/test
```

or do it manually
```bash
# assemble every file
# on linux
./asm/zig-out/bin/assembler prog/test/a.asm
# on windows
.\asm\zig-out\bin\assembler.exe prog/test/a.asm

# link all files
# on linux
./lnk/linker ./out/
# on windows
.\lnk\linker.exe ./out/

# run the emulator
# on linux
./emu/emulator -bin ./out/out.bin
# on windows
.\emu\emulator.exe -bin .\out\out.bin
```

