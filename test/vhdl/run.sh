#!/bin/sh
# Simulate the VHDL with GHDL and check against the Python reference model.
#   ./run.sh              every program in ../programs.py (plus the VHDL-only ones)
#   ./run.sh NAME...      just those programs
#   ./run.sh fpu          stand-alone FPU vectors
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
  exit
fi
$GHDL -a --std=08 -frelaxed $SRC tb.vhd
NAMES=${*:-$(python ../programs.py --list --vhdl)}
FAILED=""
for n in $NAMES; do
  python ../programs.py "$n" > /dev/null
  N=$(wc -l < expected.txt)
  CLK=20000000
  [ "$n" = tick ] && CLK=2000               # a "second" every 2000 cycles
  BOOT=$(python ../programs.py "$n" --boot)
  if $GHDL --elab-run --std=08 -frelaxed tb -gG_NRES="$N" -gG_CLK_HZ=$CLK -gG_BOOT=$BOOT --ieee-asserts=disable > sim.log 2>&1 \
     && python ../check.py > check.log; then
    echo "PASS $n ($(tail -1 check.log))"
  else
    echo "FAIL $n"; grep -hE "result|failure|error" sim.log check.log | head -5
    FAILED="$FAILED $n"
  fi
done
[ -z "$FAILED" ] || { echo "failed:$FAILED"; exit 1; }
