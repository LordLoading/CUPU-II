#!/usr/bin/env bash
set -euo pipefail

cd asm
zig build
echo "assembler built"
cd ..

cd lnk
dub build
echo "linker built"
cd ..

cd emu
go build ./
echo "emulator built"
