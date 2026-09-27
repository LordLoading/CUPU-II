#!/bin/sh
# Simulate the VHDL with GHDL and check against the Python reference model.
#   ./run.sh [seed]     full CPU test program
#   ./run.sh fpu        stand-alone FPU vectors
set -e
cd "$(dirname "$0")"
GHDL=${GHDL:-ghdl}
SRC="../../src/project.vhdl"
rm -f work-obj08.cf
if [ "$1" = "fpu" ]; then
  python gen_fpu_vectors.py
  $GHDL -a --std=08 $SRC tb_fpu.vhd
  $GHDL --elab-run --std=08 tb_fpu --ieee-asserts=disable
  python check_fpu.py
else
  python ../gen_test.py "${1:-1}"
  N=$(wc -l < expected.txt)
  $GHDL -a --std=08 -frelaxed $SRC tb.vhd
  $GHDL --elab-run --std=08 -frelaxed tb -gG_NRES="$N" --ieee-asserts=disable
  python ../check.py
fi
