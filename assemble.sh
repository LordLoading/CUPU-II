#!/usr/bin/env bash
set -euo pipefail

ASSEMBLER="asm/zig-out/bin/assembler"
LINKER="lnk/linker"

if [[ ! -x "$ASSEMBLER" ]]; then
    echo "Error: assembler not found at $ASSEMBLER" >&2
    exit 1
fi

if [[ ! -x "$LINKER" ]]; then
    echo "Error: linker not found at $LINKER" >&2
    exit 1
fi

assemble_file() {
    local asm_file="$1"
    local out_file="$2"
    local out_dir

    out_dir="$(dirname "$out_file")"
    mkdir -p "$out_dir"

    echo "Assembling: $asm_file -> $out_file"
    "$ASSEMBLER" "$asm_file" "$out_file"
}

link_files() {
    local o_dir="$1"
    local bin_out="${2:-out.bin}"

    if [[ ! -d "$o_dir" ]]; then
        echo "Warning: object directory '$o_dir' does not exist, skipping link." >&2
        return
    fi

    echo "Linking: $o_dir -> $bin_out"
    "$LINKER" "$o_dir" "$bin_out"
}

# Use find from project root, excluding build artifacts
find_asm_files() {
    find . -type f -name "*.asm" \
        -not -path "./.git/*" \
        -not -path "*/zig-out/*" \
        -not -path "*/.zig-cache/*"
}

o_output_dir=""

if [[ $# -eq 0 ]]; then
    # Default: recursively find all .asm files, output to out/<path>.o
    o_output_dir="out"
    while IFS= read -r asm_file; do
        # Strip leading ./ to avoid out/./ paths
        rel="${asm_file#./}"
        out_file="out/${rel%.asm}.o"
        assemble_file "$asm_file" "$out_file"
    done < <(find_asm_files)
elif [[ $# -eq 1 ]]; then
    input="$1"
    if [[ -f "$input" ]]; then
        # Single file -> out/<name>.o
        o_output_dir="out"
        out_file="out/${input%.asm}.o"
        assemble_file "$input" "$out_file"
    elif [[ -d "$input" ]]; then
        # Directory -> find .asm files, preserve relative structure under out/
        o_output_dir="out"
        while IFS= read -r -d '' asm_file; do
            rel="${asm_file#"$input"/}"
            out_file="out/${rel%.asm}.o"
            assemble_file "$asm_file" "$out_file"
        done < <(find "$input" -type f -name "*.asm" -print0)
    else
        echo "Error: input path '$input' does not exist" >&2
        exit 1
    fi
elif [[ $# -eq 2 ]]; then
    input="$1"
    output="$2"
    if [[ -f "$input" ]]; then
        # Single file -> explicit output file
        o_output_dir="$(dirname "$output")"
        assemble_file "$input" "$output"
    elif [[ -d "$input" ]]; then
        # Directory -> output directory, preserve relative structure
        o_output_dir="$output"
        while IFS= read -r -d '' asm_file; do
            rel="${asm_file#"$input"/}"
            out_file="${output}/${rel%.asm}.o"
            assemble_file "$asm_file" "$out_file"
        done < <(find "$input" -type f -name "*.asm" -print0)
    else
        echo "Error: input path '$input' does not exist" >&2
        exit 1
    fi
else
    echo "Usage: $0 [input_path] [output_path]" >&2
    echo "  No args   : assemble all .asm files recursively, output to out/" >&2
    echo "  1 arg     : input file -> out/<name>.o, or input dir -> out/ (recursive)" >&2
    echo "  2 args    : input file -> output file, or input dir -> output dir (recursive)" >&2
    exit 1
fi

link_files "$o_output_dir" "${o_output_dir}/out.bin"

echo "Done."
