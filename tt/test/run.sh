#!/bin/sh
# Simulate the VHDL with GHDL and check against the Python reference model.
set -e
cd "$(dirname "$0")"
GHDL=${GHDL:-ghdl}
python gen_test.py "${1:-1}"
N=$(wc -l < expected.txt)
rm -f work-obj08.cf
$GHDL -a --std=08 -frelaxed ../src/cupu_spi.vhd ../src/cupu_core.vhd ../src/tt_um_zonlykroks_cupu.vhd tb.vhd
$GHDL --elab-run --std=08 -frelaxed tb -gG_NRES="$N" --ieee-asserts=disable-at-0
python check.py
