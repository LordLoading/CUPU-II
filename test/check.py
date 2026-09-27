"""Compare results.txt (from a testbench) with expected.txt (from gen_test.py)."""

import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from fpu_ref import matches  # noqa: E402


def check(expected="expected.txt", results="results.txt", log=print):
    exp = [line.split() for line in open(expected)]
    got = open(results).read().split()
    bad = 0
    for i, (e, k) in enumerate(exp):
        e, k = int(e, 16), int(k)
        g = int(got[i], 16) if i < len(got) else None
        ok = g is not None and (g == e if k < 0 else matches(k, g, e))
        if not ok:
            bad += 1
            if bad <= 20:
                log(f"result {i}: expected {e:08x}, got {g if g is None else format(g, '08x')}")
    log(f"{len(exp) - bad}/{len(exp)} results match")
    return bad == 0


if __name__ == "__main__":
    sys.exit(0 if check() else 1)
