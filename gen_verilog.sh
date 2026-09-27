#!/bin/sh
# Convert the VHDL sources to src/project.v for the Tiny Tapeout (LibreLane) flow.
# TT's own VHDL support transpiles each file on its own, which does not work for a
# multi-file design, so the Verilog is generated here and committed.
set -e
cd "$(dirname "$0")/src"
${GHDL:-ghdl} --synth --std=08 --out=verilog \
  cupu_fpu_pkg.vhd cupu_fpu.vhd cupu_spi.vhd cupu_core.vhd tt_um_zonlykroks_cupu.vhd \
  -e tt_um_zonlykroks_cupu > project.v
echo "wrote src/project.v"
