#!/usr/bin/env bash
# for transparency, this script is written by ai because i'm a lazy bastard
set -euo pipefail

ASSEMBLE_DIR="${1:-.}"

# Clear out directory
if [[ -d out ]]; then
    rm -rf out
fi

# Assemble specified directory
./assemble.sh "$ASSEMBLE_DIR"

# Run the assembled binary in the emulator
./emu/emulator -bin ./out/out.bin
