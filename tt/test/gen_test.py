"""Generate a CUPU-II test program and the results a correct CPU must store.

Every test leaves one word in the result area at 0x100000; the program then writes
0xA5 to gpio and halts. tb.vhd dumps the result area to results.txt and
check.py compares it with expected.txt.
"""

import random
import sys

M = 0xFFFFFFFF
RES = 0x100000
KBD = 0x5A  # tb.vhd drives ui_in with this


def s32(x):
    x &= M
    return x - (1 << 32) if x & 0x80000000 else x


def sext16(x):
    x &= 0xFFFF
    return x - 0x10000 if x & 0x8000 else x


def tdiv(a, b):
    q = abs(a) // abs(b)
    return q if (a < 0) == (b < 0) else -q


# reference semantics, per isa.txt (emulator behaviour where the spec is silent)
R_OPS = {
    0x00: lambda a, b: a + b,
    0x01: lambda a, b: a - b,
    0x02: lambda a, b: s32(a) * s32(b),
    0x03: lambda a, b: tdiv(s32(a), s32(b)),
    0x04: lambda a, b: a | b,
    0x05: lambda a, b: a & b,
    0x06: lambda a, b: a ^ b,
    0x07: lambda a, b: ~a,
    0x08: lambda a, b: a << b if b < 32 else 0,
    0x09: lambda a, b: a >> b if b < 32 else 0,
    0x0A: lambda a, b: s32(a) - tdiv(s32(a), s32(b)) * s32(b),
    0x0B: lambda a, b: (s32(a) * s32(b)) >> 32,
    0x0C: lambda a, b: int(a + b + 1 > M),
    0x0D: lambda a, b: int(a <= b),
    0x0E: lambda a, b: 0,  # fpu ops are not implemented in hardware
    0x14: lambda a, b: 0,
}
CMP_OPS = {
    0x20: lambda a, b: a == b,
    0x21: lambda a, b: a != b,
    0x22: lambda a, b: a > b,
    0x23: lambda a, b: a >= b,
    0x24: lambda a, b: a < b,
    0x25: lambda a, b: a <= b,
}
I_OPS = {
    0x08: lambda a, i: a + sext16(i),
    0x09: lambda a, i: a - sext16(i),
    0x0A: lambda a, i: s32(a) * sext16(i),
    0x0B: lambda a, i: tdiv(s32(a), sext16(i)),
    0x0C: lambda a, i: a | (sext16(i) & M),
    0x0D: lambda a, i: a & (sext16(i) & M),
    0x0E: lambda a, i: a ^ (sext16(i) & M),
    0x18: lambda a, i: a + i,
    0x19: lambda a, i: a - i,
    0x1A: lambda a, i: a * i,
    0x1B: lambda a, i: a // i,
    0x1C: lambda a, i: a | i,
    0x1D: lambda a, i: a & i,
    0x1E: lambda a, i: a ^ i,
}


def R(t, a, b, fn, cond=0):
    return (cond << 31) | (t << 21) | (a << 16) | (b << 11) | fn


def I(opc, t, a, imm, cond=0):
    return (cond << 31) | (opc << 26) | (t << 21) | (a << 16) | (imm & 0xFFFF)


class Prog:
    def __init__(self):
        self.words = []
        self.expected = []

    def emit(self, w):
        self.words.append(w & M)

    def pc(self):
        return 4 * len(self.words)

    def li(self, r, v):
        self.emit(I(0x0F, r, 0, (v >> 16) & 0xFFFF))  # lui
        self.emit(I(0x1C, r, r, v & 0xFFFF))          # uori

    def store_result(self, r, value):
        self.emit(R(r, 10, 0, 0x33))   # sw r -> mem[r10]
        self.emit(I(0x08, 10, 10, 4))  # addi r10, r10, 4
        self.expected.append(value & M)


def build(seed):
    rnd = random.Random(seed)
    p = Prog()
    p.li(10, RES)

    edge = [0, 1, 2, 31, 32, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0xFFFFFFFE, 12345, 0xDEADBEEF]
    pairs = [(a, b) for a in edge for b in edge[:6]]
    pairs += [(rnd.getrandbits(32), rnd.getrandbits(32)) for _ in range(6)]
    pairs += [(rnd.getrandbits(32), rnd.randrange(40)) for _ in range(4)]

    for fn, f in R_OPS.items():
        for a, b in pairs:
            if fn in (0x03, 0x0A) and b == 0:
                continue  # division by zero is undefined
            p.li(1, a)
            p.li(2, b)
            p.emit(R(3, 1, 2, fn))
            p.store_result(3, f(a, b))

    for fn, f in CMP_OPS.items():
        for a, b in pairs[:20]:
            p.li(1, a)
            p.li(2, b)
            p.emit(I(0x08, 3, 0, 7))              # addi r3, $z, 7
            p.emit(R(0, 1, 2, fn))                # compare -> flag
            p.emit(I(0x08, 3, 0, 1, cond=1))      # if flag: addi r3, $z, 1
            p.store_result(3, 1 if f(a, b) else 7)

    imms = [0, 1, 3, 0x7FFF, 0x8000, 0xFFFF, 0x1234, 0xFFFE]
    for opc, f in I_OPS.items():
        for a in edge[:8] + [rnd.getrandbits(32)]:
            for imm in imms:
                if opc in (0x0B, 0x1B) and imm == 0:
                    continue
                p.li(1, a)
                p.emit(I(opc, 3, 1, imm))
                p.store_result(3, f(a, imm))

    # lui alone
    p.emit(I(0x0F, 3, 0, 0xBEEF))
    p.store_result(3, 0xBEEF0000)

    # writing $z has no effect
    p.emit(I(0x08, 0, 0, 55))
    p.store_result(0, 0)

    # jal: absolute jump, link = pc + 4
    p.li(5, 0)
    at = p.pc() + 8
    p.li(7, at + 12 - 0x10)
    p.emit(I(0x10, 4, 7, 0x10))      # jal r4, r7, 0x10 -> at + 12
    p.emit(I(0x08, 5, 0, 99))        # skipped
    p.emit(I(0x08, 5, 0, 98))        # skipped
    p.emit(I(0x08, 5, 5, 1))         # target: r5 += 1
    p.store_result(4, at + 4)
    p.store_result(5, 1)

    # jral: pc = pc + imm + $a
    p.li(6, 4)
    at = p.pc()
    p.emit(I(0x11, 4, 6, 8))         # jral r4, r6, 8 -> at + 12
    p.emit(I(0x08, 5, 0, 99))
    p.emit(I(0x08, 5, 0, 98))
    p.emit(I(0x08, 5, 5, 1))
    p.store_result(4, at + 4)
    p.store_result(5, 2)

    # skipped conditional does not change flag or registers
    p.li(1, 5)
    p.emit(R(0, 1, 1, 0x21))         # neq -> flag = 0
    p.emit(I(0x08, 1, 0, 77, cond=1))
    p.store_result(1, 5)

    # memory, including RAM B (addr bit 23) and sub-word accesses
    for base in (0x2000, 0x800100):
        p.li(20, base)
        p.li(21, 0x11223344)
        p.emit(R(21, 20, 0, 0x33))                 # sw
        p.emit(R(3, 20, 0, 0x30))                  # lw
        p.store_result(3, 0x11223344)
        p.emit(I(0x08, 22, 20, 1))
        p.emit(R(3, 22, 0, 0x32))                  # lb +1
        p.store_result(3, 0x33)
        p.emit(I(0x08, 22, 20, 2))
        p.emit(R(3, 22, 0, 0x31))                  # lh +2
        p.store_result(3, 0x1122)
        p.li(21, 0xCAFEF0AB)
        p.emit(R(21, 22, 0, 0x35))                 # sb +2
        p.emit(R(3, 20, 0, 0x30))
        p.store_result(3, 0x11AB3344)
        p.emit(R(21, 20, 0, 0x34))                 # sh +0
        p.emit(R(3, 20, 0, 0x30))
        p.store_result(3, 0x11ABF0AB)

    # the RAM A copy must be untouched by the RAM B writes
    p.li(20, 0x2000)
    p.emit(R(3, 20, 0, 0x30))
    p.store_result(3, 0x11ABF0AB)

    # mmio: keyboard, gpio readback, seconds counter (0 in a short sim)
    p.li(20, 0x20000004)
    p.emit(R(3, 20, 0, 0x32))
    p.store_result(3, KBD)
    p.li(20, 0x20000008)
    p.li(21, 0x3C)
    p.emit(R(21, 20, 0, 0x35))
    p.emit(R(3, 20, 0, 0x32))
    p.store_result(3, 0x3C)
    p.li(20, 0x20000000)
    p.emit(R(3, 20, 0, 0x30))
    p.store_result(3, 0)

    # done: gpio = 0xA5, halt
    p.li(20, 0x20000008)
    p.li(21, 0xA5)
    p.emit(R(21, 20, 0, 0x35))
    p.emit(R(0, 0, 0, 0x40))
    p.emit(I(0x08, 30, 0, 1))        # must never run
    return p


if __name__ == "__main__":
    p = build(int(sys.argv[1]) if len(sys.argv) > 1 else 1)
    assert 4 * len(p.words) < RES, "program overlaps result area"
    with open("prog.hex", "w") as f:
        f.writelines(f"{w:08x}\n" for w in p.words)
    with open("expected.txt", "w") as f:
        f.writelines(f"{w:08x}\n" for w in p.expected)
    print(f"{len(p.words)} instructions, {len(p.expected)} results")
