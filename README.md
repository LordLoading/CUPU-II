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
- **R-type**: `cond: 1 bit`, `opcode: 5 bit`, `target: 5 bit`, `a: 5 bit`, `b: 5 bit`, `func11: 11 bit`
- **I-type**: `cond: 1 bit`, `opcode: 5 bit`, `target: 5 bit`, `a: 5 bit`, `immediate: 16 bit`

- Addressspace: 32 bits (not all are mapped to ram but you could do that without any issues)
- Addressresolution: 8 bits (how many bits are stored in one address)

### Some Quirks
#### Conditionals
Conditional bit: when set, the instruction only executes if the condition flag is set.
To set the condition flag you can compare 2 registers. If the comparison is true, the condition flag is set and vice versa.
#### Load Immediate
To load a big number like `0x12345678` into a register, you need to use `lui` followed by `uaddi`.
This is because we can only load 16 bit immediates at a time. using `addi` would sign extend the number, so you would have to be very careful with the upper half.
#### Jumps
Jumps can be absolute with `jal` or relative with `jral`.
The "al" part means "and link", aka the it stores the address of the next instruction in the register of your choice.
To discard the linked address, just write it to `$0` as this is "hardwired" to zero.
#### Memory Operations
Memory operations are done with `lw`, `lh`, `lb`, `sw`, `sh`, `sb`.
The `lw` and `sw` instructions are for 32 bit words, the `lh` and `sh` are for 16 bit halfwords, and the `lb` and `sb` are for 8 bit bytes.
You have to provide the address you want to read/write to in a register, so be sure to load it first and calculate offsets, as you cant use immediates with these instructions.

For more details, see [`isa.txt`](isa.txt)

## Build
To fully use this Project, you will need to build the assembler, linker, and emulator.
To do that you will need zig, d, and golang. (sorry, i just wanted to try stuff out)

Use the build script
```bash
# on linux
sh build.sh
# on windows
build.ps1
```

Or do it manually
```bash
# build assembler
cd asm && zig build

# build linker
cd lnk && dub build

# build emulator
cd emu && go build ./
```

## Usage
Use the run script
```bash
# on linux
sh run.sh
# on windows
run.ps1
```

Or assemble and link without running the emulator
```bash
# on linux
sh assemble.sh prog/test
# on windows
assemble.ps1 prog/test
```

Or do it manually
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

---

idk what else to tell you.
go make something great :)
