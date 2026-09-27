"""Compare results.txt (from tb.vhd) with expected.txt (from gen_test.py)."""

import sys

exp = open("expected.txt").read().split()
got = open("results.txt").read().split()
bad = [(i, e, g) for i, (e, g) in enumerate(zip(exp, got)) if int(e, 16) != int(g, 16)]
for i, e, g in bad[:20]:
    print(f"result {i}: expected {e}, got {g}")
print(f"{len(exp) - len(bad)}/{len(exp)} results match")
sys.exit(1 if bad or len(got) < len(exp) else 0)
