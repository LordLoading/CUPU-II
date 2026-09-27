#!/bin/sh
# Simulate the VHDL with GHDL and check against the Python reference model.
#   ./run.sh [seed]     full CPU test program
#   ./run.sh fpu        stand-alone FPU vectors
set -e
cd "$(dirname "$0")"
GHDL=${GHDL:-ghdl}
SRC="../../src/cupu_fpu_pkg.vhd ../../src/cupu_fpu.vhd ../../src/cupu_spi.vhd ../../src/cupu_core.vhd ../../src/tt_um_zonlykroks_cupu.vhd"
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
