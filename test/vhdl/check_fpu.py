"""Compare fpu_results.txt from tb_fpu.vhd with the reference."""

import os
import sys
from collections import Counter

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from fpu_ref import matches  # noqa: E402

NAMES = ["itof", "ftoi", "fadd", "fsub", "fmul", "fdiv", "sqrt", "sin", "cos", "tan"]
bad, inexact, total = Counter(), Counter(), Counter()
shown = 0
for line in open("fpu_results.txt"):
    op, a, b, exp, got = (int(x, 16) for x in line.split())
    total[op] += 1
    if not matches(op, got, exp):
        bad[op] += 1
        if shown < 25:
            print(f"{NAMES[op]} a={a:08x} b={b:08x} expected {exp:08x} got {got:08x}")
            shown += 1
    elif got != exp and (exp & 0x7F800000) != 0x7F800000:
        inexact[op] += 1
for op in range(10):
    print(f"{NAMES[op]:5} {total[op] - bad[op]:5}/{total[op]} ok, {inexact[op]} off by 1 ulp")
sys.exit(1 if bad else 0)
