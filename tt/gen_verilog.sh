#!/bin/sh
# Convert the VHDL sources to src/project.v for the Tiny Tapeout (LibreLane) flow.
set -e
cd "$(dirname "$0")/src"
${GHDL:-ghdl} --synth --std=08 --out=verilog \
  cupu_spi.vhd cupu_core.vhd tt_um_zonlykroks_cupu.vhd \
  -e tt_um_zonlykroks_cupu > project.v
echo "wrote src/project.v"
