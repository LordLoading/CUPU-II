"""Write fpu_vectors.txt (op a b expected) for tb_fpu.vhd."""

import math
import os
import random
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from fpu_ref import f2b, fpu  # noqa: E402

rnd = random.Random(int(sys.argv[1]) if len(sys.argv) > 1 else 1)

SPECIAL = [0x00000000, 0x80000000, 0x7F800000, 0xFF800000, 0x7FC00000, 0x00000001, 0x80000001,
           0x007FFFFF, 0x00800000, 0x3F800000, 0xBF800000, 0x7F7FFFFF, 0xFF7FFFFF, 0x3F000000,
           0x40490FDB, 0x3FC90FDB, 0x4F000000, 0xCF000000, 0x4EFFFFFF, 0x3EFFFFFF, 0x00400000]


def rbits():
    k = rnd.randrange(6)
    if k == 0:
        return rnd.choice(SPECIAL)
    if k == 1:  # subnormal
        return rnd.getrandbits(23) | (rnd.getrandbits(1) << 31)
    if k == 2:  # moderate range
        return f2b(rnd.uniform(-1000, 1000))
    if k == 3:  # near 1
        return f2b(rnd.uniform(0.5, 2)) ^ rnd.getrandbits(4)
    return rnd.getrandbits(32)


def int_arg():
    return rnd.choice([rnd.getrandbits(32), rnd.randrange(-100, 100) & 0xFFFFFFFF, rbits(),
                       f2b(rnd.randrange(-50, 50) + 0.5)])


def trig_arg():
    k = rnd.randrange(6)
    if k == 0:
        return f2b(rnd.uniform(-10, 10))
    if k == 1:
        return f2b(rnd.uniform(-1e6, 1e6))
    if k == 2:  # near multiples of pi/2
        return (f2b(rnd.randrange(-2000, 2000) * math.pi / 2) + rnd.randrange(-3, 4)) & 0xFFFFFFFF
    if k == 3:
        return f2b(math.ldexp(rnd.uniform(1, 2), rnd.randrange(-16, 2))) | (rnd.getrandbits(1) << 31)
    return rbits()


def vectors(per_op=3000, trig=1500):
    vec = []
    for op in range(10):
        for a in SPECIAL:
            for b in SPECIAL[:8]:
                vec.append((op, a, b))
        for _ in range(trig if op >= 7 else per_op):
            if op >= 7:
                a = trig_arg()
            elif op <= 1:
                a = int_arg()
            else:
                a = rbits()
            vec.append((op, a, rbits()))
    return [(op, a, b, fpu(op, a, b)) for op, a, b in vec]


if __name__ == "__main__":
    vec = vectors()
    with open("fpu_vectors.txt", "w") as f:
        for v in vec:
            f.write("%x %08x %08x %08x\n" % v)
    print(len(vec), "vectors")
