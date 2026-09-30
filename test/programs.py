"""One small self-checking program per feature. Run as a script to write prog.hex/expected.txt:

    python programs.py --list
    python programs.py NAME [--quick]
"""

import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cupu import (  # noqa: E402
    ADDI, CMP_OPS, DIVI, DONE, FAIL, FLASH, GPIN, GPIO, HLT, I, I_OPS, IN1, IN2, JAL, JRAL, LB, LH,
    LUI, LW, M, MULI, Prog, R, R_OPS, RES, SB, SH, SW, TIMESTAMP, UDIVI, WAIT_IN, write_files,
)
from fpu_ref import f2b, fpu  # noqa: E402

EDGE = [0, 1, 2, 31, 32, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0xFFFFFFFE, 12345, 0xDEADBEEF]
EDGE_Q = [1, 0x80000000, 0xFFFFFFFF, 0xDEADBEEF]


def pairs(rnd, quick):
    edge = EDGE_Q if quick else EDGE
    ps = [(a, b) for a in edge for b in edge[:6]]
    ps += [(rnd.getrandbits(32), rnd.getrandbits(32)) for _ in range(2 if quick else 6)]
    ps += [(rnd.getrandbits(32), rnd.randrange(40)) for _ in range(1 if quick else 4)]
    return ps


def rtype(name, fns, rnd, quick):
    p = Prog(name)
    for fn in fns:
        for a, b in pairs(rnd, quick):
            if fn in (0x03, 0x0A) and b == 0:
                continue                      # division by zero halts: see halt_* tests
            p.li(1, a)
            p.li(2, b)
            p.emit(R(3, 1, 2, fn))
            p.store_result(3, R_OPS[fn](a, b))
    return p.finish()


# ---------------------------------------------------------------------------
def p_reset(rnd, quick):
    """Registers are 0 after reset, $z reads 0 and ignores writes, the flag starts clear."""
    p = Prog("reset")
    for r in range(1, 32):
        if r != p.ptr:
            p.store_result(r, 0)
    p.emit(I(ADDI, 0, 0, 55))
    p.store_result(0, 0)
    p.emit(R(0, 10, 10, 0x00))               # add $z, r10, r10
    p.store_result(0, 0)
    p.emit(I(ADDI, 3, 0, 9, cond=1))         # skipped: flag is clear
    p.store_result(3, 0)
    return p.finish()


def p_registers(rnd, quick):
    """Every register holds its own value (each one is a separate ring in hardware)."""
    p = Prog("registers", ptr=31)
    vals = {r: rnd.getrandbits(32) for r in range(1, 31)}
    for r in range(1, 31):
        p.li(r, vals[r])
    for r in range(1, 31):
        p.store_result(r, vals[r])
    for r in range(1, 31):                    # complement in place: every bit both ways
        p.emit(R(r, r, 0, 0x07))
    for r in range(1, 31):
        p.store_result(r, ~vals[r])
    p.ptr = 1                                 # r31 itself, with r1 as the pointer
    p.li(1, RES + 4 * len(p.expected))
    v = rnd.getrandbits(32)
    p.li(31, v)
    p.store_result(31, v)
    p.emit(R(31, 31, 0, 0x07))
    p.store_result(31, ~v)
    return p.finish()


def p_arith(rnd, quick):
    return rtype("arith", [0x00, 0x01, 0x0C, 0x0D], rnd, quick)


def p_logic(rnd, quick):
    return rtype("logic", [0x04, 0x05, 0x06, 0x07], rnd, quick)


def p_shift(rnd, quick):
    p = Prog("shift")
    amounts = [0, 1, 31, 32, 33, 0xFFFFFFFF] if quick else \
        [0, 1, 2, 5, 16, 30, 31, 32, 33, 63, 0x80000000, 0xFFFFFFFF]
    for fn in (0x08, 0x09):
        for a in (EDGE_Q if quick else EDGE):
            for b in amounts:
                p.li(1, a)
                p.li(2, b)
                p.emit(R(3, 1, 2, fn))
                p.store_result(3, R_OPS[fn](a, b))
    return p.finish()


def p_muldiv(rnd, quick):
    return rtype("muldiv", [0x02, 0x0B, 0x03, 0x0A], rnd, quick)


def p_imm(rnd, quick):
    p = Prog("imm")
    imms = [1, 0x8000, 0xFFFF] if quick else [0, 1, 3, 0x7FFF, 0x8000, 0xFFFF, 0x1234, 0xFFFE]
    for opc, f in I_OPS.items():
        for a in (EDGE_Q if quick else EDGE[:8]) + [rnd.getrandbits(32)]:
            for imm in imms:
                if opc in (DIVI, UDIVI) and imm == 0:
                    continue
                p.li(1, a)
                p.emit(I(opc, 3, 1, imm))
                p.store_result(3, f(a, imm))
    for imm in (0, 1, 0x8000, 0xBEEF, 0xFFFF):
        p.emit(I(LUI, 3, 0, imm))
        p.store_result(3, imm << 16)
    p.li(1, 0x12345678)                       # lui ignores $a
    p.emit(I(LUI, 3, 1, 0x00AB))
    p.store_result(3, 0x00AB0000)
    return p.finish()


def p_compare(rnd, quick):
    p = Prog("compare")
    for fn, f in CMP_OPS.items():
        for a, b in pairs(rnd, quick)[: 8 if quick else 24]:
            p.li(1, a)
            p.li(2, b)
            p.emit(I(ADDI, 3, 0, 7))
            p.emit(R(0, 1, 2, fn))            # flag = a op b
            p.emit(I(ADDI, 3, 0, 1, cond=1))  # if flag: r3 = 1
            p.store_result(3, 1 if f(a, b) else 7)
    return p.finish()


def p_conditional(rnd, quick):
    """Every kind of instruction with the condition bit, flag clear (skipped) and set (runs)."""
    p = Prog("conditional")
    A, B = 0x2000, 0x2004
    for flag in (0, 1):
        p.li(1, 5)
        p.li(2, 5 if flag else 6)
        p.emit(R(0, 1, 2, 0x20))             # eq -> flag
        # a few ordinary instructions must not disturb the flag
        p.emit(I(ADDI, 9, 0, 1))
        p.li(20, A)
        p.li(21, 0x11112222)
        p.emit(R(21, 20, 0, SW))             # mem[A] = 0x11112222
        p.li(20, B)
        p.li(21, 0x33334444)
        p.emit(R(21, 20, 0, SW))             # mem[B] = 0x33334444

        p.li(3, 7)                           # alu
        p.emit(I(ADDI, 3, 0, 1, cond=1))
        p.store_result(3, 1 if flag else 7)

        p.li(3, 7)                           # r-type alu
        p.emit(R(3, 1, 1, 0x00, cond=1))
        p.store_result(3, 10 if flag else 7)

        p.li(3, 7)                           # mul and div
        p.emit(R(3, 1, 1, 0x02, cond=1))
        p.store_result(3, 25 if flag else 7)
        p.li(3, 7)
        p.emit(R(3, 1, 1, 0x03, cond=1))
        p.store_result(3, 1 if flag else 7)

        p.li(3, 7)                           # fpu
        p.emit(R(3, 1, 0, 0x0E, cond=1))     # itof 5
        p.store_result(3, f2b(5.0) if flag else 7)

        p.li(4, 0x55)                        # load
        p.li(20, A)
        p.emit(R(4, 20, 0, LW, cond=1))
        p.store_result(4, 0x11112222 if flag else 0x55)

        p.li(5, 0x66667777)                  # store
        p.li(20, B)
        p.emit(R(5, 20, 0, SW, cond=1))
        p.emit(R(4, 20, 0, LW))
        p.store_result(4, 0x66667777 if flag else 0x33334444)

        p.li(6, 0x99)                        # jal: jump over one instruction
        at = p.pc() + 8
        p.li(7, at + 8)
        p.emit(I(JAL, 6, 7, 0, cond=1))
        p.emit(I(ADDI, 8, 0, 3))             # only when not jumping
        p.store_result(6, at + 4 if flag else 0x99)
        p.store_result(8, 0 if flag else 3)
        p.emit(I(ADDI, 8, 0, 0))

        p.li(6, 0x99)                        # jral
        at = p.pc()
        p.emit(I(JRAL, 6, 0, 8, cond=1))
        p.emit(I(ADDI, 8, 0, 3))
        p.store_result(6, at + 4 if flag else 0x99)
        p.store_result(8, 0 if flag else 3)
        p.emit(I(ADDI, 8, 0, 0))

        p.li(3, 7)                           # compare: a skipped compare leaves the flag
        p.emit(R(0, 0, 0, 0x21, cond=1))     # neq $z,$z -> would clear the flag
        p.emit(I(ADDI, 3, 0, 2, cond=1))
        p.store_result(3, 7)                 # flag 0: both skipped; flag 1: cmp ran, cleared it

        if not flag:
            p.emit(R(0, 0, 0, HLT, cond=1))  # halt: skipped
            p.emit(I(ADDI, 3, 0, 11))
            p.store_result(3, 11)
            p.li(20, GPIO)                    # gpio store: skipped
            p.li(21, 0x42)
            p.emit(R(21, 20, 0, SB, cond=1))
            p.emit(R(3, 20, 0, LB))
            p.store_result(3, 0)
    return p.finish()


def p_jumps(rnd, quick):
    p = Prog("jumps")
    p.li(5, 0)                                # jal: absolute, link = pc + 4
    at = p.pc() + 8
    p.li(7, at + 12 - 0x10)
    p.emit(I(JAL, 4, 7, 0x10))
    p.emit(I(ADDI, 5, 0, 99))
    p.emit(I(ADDI, 5, 0, 98))
    p.emit(I(ADDI, 5, 5, 1))
    p.store_result(4, at + 4)
    p.store_result(5, 1)

    p.li(6, 4)                                # jral: pc = pc + imm + $a
    at = p.pc()
    p.emit(I(JRAL, 4, 6, 8))
    p.emit(I(ADDI, 5, 0, 99))
    p.emit(I(ADDI, 5, 0, 98))
    p.emit(I(ADDI, 5, 5, 1))
    p.store_result(4, at + 4)
    p.store_result(5, 2)

    at = p.pc() + 8                           # jal with $t == $a: $a is read first
    p.li(8, at + 8)
    p.emit(I(JAL, 8, 8, 0))
    p.emit(I(ADDI, 5, 0, 99))
    p.store_result(8, at + 4)
    p.store_result(5, 2)

    # backward loop: r2 = 10 + 9 + ... + 1
    p.li(1, 10)
    p.li(2, 0)
    loop = p.pc()
    p.emit(R(2, 2, 1, 0x00))
    p.emit(I(ADDI, 1, 1, -1))
    p.emit(R(0, 1, 0, 0x21))                  # neq r1, $z
    p.emit(I(JRAL, 0, 0, loop - p.pc(), cond=1))
    p.store_result(2, 55)
    p.store_result(1, 0)

    # call and return: sub adds 100 to r3, returns through r9
    p.li(3, 1)
    call = p.pc()
    p.emit(I(JRAL, 9, 0, 8))                  # call sub (2 words ahead)
    p.emit(I(JRAL, 0, 0, 12))                 # return lands here: skip over sub
    p.emit(I(ADDI, 3, 3, 100))                # sub:
    p.emit(I(JAL, 0, 9, 0))                   #     return (pc = r9)
    p.store_result(3, 101)
    p.store_result(9, call + 4)
    return p.finish()


class Mem:
    """Byte memory model: little endian, and the two PSRAMs are separate 8 MiB chips."""

    def __init__(self):
        self.b = {}

    def write(self, addr, value, n):
        for k in range(n):
            self.b[addr + k] = (value >> (8 * k)) & 0xFF

    def read(self, addr, n):
        return sum(self.b.get(addr + k, 0) << (8 * k) for k in range(n))


def p_memory(rnd, quick):
    p = Prog("memory")
    mem = Mem()
    size = {LW: 4, LH: 2, LB: 1, SW: 4, SH: 2, SB: 1}

    def store(fn, addr, v):
        p.li(20, addr)
        p.li(21, v)
        p.emit(R(21, 20, 0, fn))
        mem.write(addr, v, size[fn])

    def load(fn, addr):
        p.li(20, addr)
        p.emit(R(3, 20, 0, fn))
        p.store_result(3, mem.read(addr, size[fn]))

    bases = [0x2000, 0x800100] if quick else [0x2000, 0x800100, 0x7FFFE0, 0xFFFFE0, 0x6000]
    for base in bases:
        store(SW, base, 0x80FF7F01)
        store(SW, base + 4, 0xCAFEBABE)
        for off in range(4):
            load(LB, base + off)             # zero extension of 0x80 / 0xFF bytes
        for off in (0, 1, 2) if not quick else (0, 1):
            load(LH, base + off)
        for off in (0, 1, 2, 3) if not quick else (0, 3):
            load(LW, base + off)             # unaligned words
        store(SB, base + 2, 0x12345678)
        load(LW, base)
        store(SH, base + 1, 0xABCD)          # unaligned halfword
        load(LW, base)
        store(SW, base + 3, 0x0BADF00D)      # unaligned word across two words
        load(LW, base)
        load(LW, base + 4)
    # the two chips are separate: same low address bits, different contents
    store(SW, 0x3000, 0xAAAAAAAA)
    store(SW, 0x803000, 0x55555555)
    load(LW, 0x3000)
    load(LW, 0x803000)
    return p.finish()


def p_mmio(rnd, quick):
    p = Prog("mmio")
    mem_sz = {LW: 4, LH: 2, LB: 1}
    gpio = 0

    def gpio_store(fn, v):
        nonlocal gpio
        p.li(20, GPIO)
        p.li(21, v)
        p.emit(R(21, 20, 0, fn))
        gpio = v & 0xFF                       # any store to 0x20000008 sets gpio to the low byte

    for fn, v in ((SB, 0x12), (SH, 0x3456), (SW, 0x789ABC77)):
        gpio_store(fn, v)
        for ld in (LB, LH, LW):
            p.li(20, GPIO)
            p.emit(R(3, 20, 0, ld))
            p.store_result(3, gpio)

    ts = 1700000000                           # timestamp: word stores set it (no second passes)
    p.li(20, TIMESTAMP)
    p.li(21, ts)
    p.emit(R(21, 20, 0, SW))
    for ld, off in ((LW, 0), (LH, 0), (LH, 2), (LB, 0), (LB, 1), (LB, 2), (LB, 3)):
        p.li(20, TIMESTAMP + off)
        p.emit(R(3, 20, 0, ld))
        p.store_result(3, (ts >> (8 * off)) & ((1 << (8 * mem_sz[ld])) - 1))
    p.li(20, TIMESTAMP)                       # byte and halfword stores do not set it
    p.li(21, 7)
    p.emit(R(21, 20, 0, SB))
    p.emit(R(21, 20, 0, SH))
    p.emit(R(3, 20, 0, LW))
    p.store_result(3, ts)

    for addr in (0x20000005, 0x2000000C, 0x20000010, 0x30000000, 0xFF000000):  # unmapped: 0
        p.li(20, addr)
        p.li(21, 0x5555)
        p.emit(R(21, 20, 0, SW))              # ignored
        p.emit(R(3, 20, 0, LB if addr == 0x20000005 else LW))
        p.store_result(3, 0)

    for fn in (LB, LH, LW):                   # gpio inputs: ui_in = IN1 since reset
        p.li(20, GPIN)
        p.emit(R(3, 20, 0, fn))
        p.store_result(3, IN1)                # bytes 5..7 read 0
    p.li(20, GPIN)                            # the inputs cannot be written
    p.li(21, 0x77777777)
    p.emit(R(21, 20, 0, SW))
    p.emit(R(21, 20, 0, SB))
    p.emit(R(3, 20, 0, LB))
    p.store_result(3, IN1)
    p.gpio(WAIT_IN)                           # the testbench switches ui_in to IN2 after a while
    p.li(20, GPIN)
    p.li(21, IN2)
    p.li(22, 0)
    loop = p.pc()                             # poll until the new value shows up
    p.emit(I(ADDI, 22, 22, 1))
    p.emit(R(3, 20, 0, LB))
    p.emit(R(0, 3, 21, 0x21))                 # r3 != IN2
    p.emit(I(JRAL, 0, 0, loop - p.pc(), cond=1))
    p.store_result(3, IN2)
    p.li(1, 2)                                # it took more than one read
    p.emit(R(0, 22, 1, 0x23))                 # polls >= 2
    p.emit(R(1, 0, 0, 0x00))
    p.emit(I(ADDI, 1, 0, 1, cond=1))
    p.store_result(1, 1)
    return p.finish()


FLOATS = [0x00000000, 0x80000000, 0x3F800000, 0xBF800000, 0x7F800000, 0xFF800000, 0x7FC00000,
          0x00000001, 0x007FFFFF, 0x7F7FFFFF, 0x40490FDB, 0x3FC90FDB, 0x4F000000, 0xCF000000]
FPU_NAMES = ["itof", "ftoi", "fadd", "fsub", "fmul", "fdiv", "sqrt", "sin", "cos", "tan"]


def fpu_prog(op):
    def build(rnd, quick):
        p = Prog("fpu_" + FPU_NAMES[op])
        fl = FLOATS[:7] if quick else FLOATS
        cases = [(a, b) for a in fl for b in fl[: 2 if quick else 6]]
        for _ in range(3 if quick else 30):
            if op <= 1:
                a = rnd.choice([rnd.getrandbits(32), rnd.randrange(-100, 100) & M,
                                f2b(rnd.randrange(-50, 50) + 0.5)])
            elif op >= 7:
                a = f2b(rnd.uniform(-1e4, 1e4)) if rnd.random() < 0.7 else rnd.getrandbits(32)
            else:
                a = rnd.getrandbits(32) if rnd.random() < 0.5 else f2b(rnd.uniform(-100, 100))
            b = f2b(rnd.uniform(-100, 100)) if rnd.random() < 0.5 else rnd.getrandbits(32)
            cases.append((a, b))
        if op >= 7 and not quick:             # large arguments and near multiples of pi/2
            for k in (1, 2, 3, 1000, 123456):
                cases.append((f2b(k * math.pi / 2), 0))
            cases.append((0x7F7FFFFF, 0))
        for a, b in cases:
            p.li(1, a)
            p.li(2, b)
            p.emit(R(3, 1, 2, 0x0E + op))
            p.store_result(3, fpu(op, a, b), op)
        return p.finish()
    return build


def halt_prog(name, emit):
    def build(rnd, quick):
        p = Prog(name)
        p.li(1, 7)
        p.store_result(1, 7)
        return p.finish(halt=emit)
    return build


def p_program(rnd, quick):
    """A few small real programs: dependent chains, fibonacci, memcpy."""
    p = Prog("program")
    p.li(1, 0)                                # back-to-back dependent writes and reads
    for _ in range(20):
        p.emit(I(ADDI, 1, 1, 3))
    p.store_result(1, 60)

    p.li(1, 0)                                # fibonacci: store fib(1..n)
    p.li(2, 1)
    p.li(4, 20 if not quick else 8)
    fib = [0, 1]
    loop = p.pc()
    p.emit(R(3, 1, 2, 0x00))                  # r3 = r1 + r2
    p.emit(I(ADDI, 1, 2, 0))                  # r1 = r2
    p.emit(I(ADDI, 2, 3, 0))                  # r2 = r3
    p.emit(R(3, 10, 0, SW))
    p.emit(I(ADDI, 10, 10, 4))
    p.emit(I(ADDI, 4, 4, -1))
    p.emit(R(0, 4, 0, 0x21))
    p.emit(I(JRAL, 0, 0, loop - p.pc(), cond=1))
    for _ in range(20 if not quick else 8):
        fib.append(fib[-1] + fib[-2])
        p.expected.append((fib[-1] & M, -1))

    n = 16 if not quick else 4                # memcpy of n words, then check the copy
    src, dst = 0x4000, 0x5000
    words = [rnd.getrandbits(32) for _ in range(n)]
    for k, w in enumerate(words):
        p.li(20, src + 4 * k)
        p.li(21, w)
        p.emit(R(21, 20, 0, SW))
    p.li(1, src)
    p.li(2, dst)
    p.li(4, n)
    loop = p.pc()
    p.emit(R(3, 1, 0, LW))
    p.emit(R(3, 2, 0, SW))
    p.emit(I(ADDI, 1, 1, 4))
    p.emit(I(ADDI, 2, 2, 4))
    p.emit(I(ADDI, 4, 4, -1))
    p.emit(R(0, 4, 0, 0x21))
    p.emit(I(JRAL, 0, 0, loop - p.pc(), cond=1))
    for k, w in enumerate(words):
        p.li(20, dst + 4 * k)
        p.emit(R(3, 20, 0, LW))
        p.store_result(3, w)
    return p.finish()


def p_flash_boot(rnd, quick):
    """Boot straight from the flash (strap high): code and data are read from it, stores to it
    are ignored, the PSRAM still works."""
    p = Prog("flash_boot", base=FLASH, boot_flash=True)
    mem = Mem()
    data = [0x80FF7F01, 0xCAFEBABE, 0x12345678, 0xDEADBEEF]
    p.emit(I(JRAL, 0, 0, 4 + 4 * len(data)))  # jump over the data
    dbase = p.pc()
    for k, w in enumerate(data):
        p.emit(w)
        mem.write(dbase + 4 * k, w, 4)
    size = {LW: 4, LH: 2, LB: 1}
    for fn, off in ((LW, 0), (LW, 4), (LW, 2), (LH, 1), (LH, 6), (LB, 0), (LB, 3), (LB, 13)):
        p.li(20, dbase + off)
        p.emit(R(3, 20, 0, fn))
        p.store_result(3, mem.read(dbase + off, size[fn]))
    p.li(20, dbase)                           # stores to the flash are ignored
    p.li(21, 0x11111111)
    p.emit(R(21, 20, 0, SW))
    p.emit(R(21, 20, 0, SB))
    p.emit(R(3, 20, 0, LW))
    p.store_result(3, data[0])

    at = p.pc() + 8                           # absolute jump inside the flash
    p.li(7, at + 8)
    p.emit(I(JAL, 6, 7, 0))
    p.emit(I(ADDI, 5, 0, 99))
    p.store_result(6, at + 4)
    p.store_result(5, 0)
    p.li(1, 10)                               # a loop
    p.li(2, 0)
    loop = p.pc()
    p.emit(R(2, 2, 1, 0x00))
    p.emit(I(ADDI, 1, 1, -1))
    p.emit(R(0, 1, 0, 0x21))
    p.emit(I(JRAL, 0, 0, loop - p.pc(), cond=1))
    p.store_result(2, 55)
    p.li(20, 0x2000)                          # the PSRAM still works
    p.li(21, 0x5EED5EED)
    p.emit(R(21, 20, 0, SW))
    p.emit(R(3, 20, 0, LW))
    p.store_result(3, 0x5EED5EED)
    return p.finish()


def p_flash_data(rnd, quick):
    """Running from the PSRAM, read the flash (which holds this program too)."""
    p = Prog("flash_data")
    first = list(p.words)                     # the words already emitted: li r10, RES
    for k in range(len(first)):
        p.li(20, FLASH + 4 * k)
        p.emit(R(3, 20, 0, LW))
        p.store_result(3, first[k])
    p.li(20, FLASH + 1)
    p.emit(R(3, 20, 0, LB))
    p.store_result(3, (first[0] >> 8) & 0xFF)
    p.li(20, FLASH + 2)
    p.emit(R(3, 20, 0, LH))
    p.store_result(3, (first[0] >> 16) & 0xFFFF)
    p.li(20, FLASH)                           # stores are ignored
    p.li(21, 0x22222222)
    p.emit(R(21, 20, 0, SW))
    p.emit(R(3, 20, 0, LW))
    p.store_result(3, first[0])
    return p.finish()


def p_tick(rnd, quick):
    """Seconds counter ticks (needs a tiny G_CLK_HZ, so only the VHDL testbench runs it)."""
    p = Prog("tick")
    p.li(20, TIMESTAMP)
    p.li(21, 41)
    p.emit(R(21, 20, 0, SW))
    loop = p.pc()
    p.emit(R(3, 20, 0, LW))
    p.emit(R(0, 3, 21, 0x20))                 # eq: still 41?
    p.emit(I(JRAL, 0, 0, loop - p.pc(), cond=1))
    p.store_result(3, 42)
    return p.finish()


PROGRAMS = {
    "reset": p_reset,
    "registers": p_registers,
    "arith": p_arith,
    "logic": p_logic,
    "shift": p_shift,
    "muldiv": p_muldiv,
    "imm": p_imm,
    "compare": p_compare,
    "conditional": p_conditional,
    "jumps": p_jumps,
    "memory": p_memory,
    "mmio": p_mmio,
    "program": p_program,
    "flash_boot": p_flash_boot,
    "flash_data": p_flash_data,
    **{"fpu_" + n: fpu_prog(i) for i, n in enumerate(FPU_NAMES)},
    "halt_hlt": halt_prog("halt_hlt", None),
    "halt_div0": halt_prog("halt_div0", lambda p: p.emit(R(3, 1, 0, 0x03))),
    "halt_rem0": halt_prog("halt_rem0", lambda p: p.emit(R(3, 1, 0, 0x0A))),
    "halt_divi0": halt_prog("halt_divi0", lambda p: p.emit(I(DIVI, 3, 1, 0))),
    "halt_udivi0": halt_prog("halt_udivi0", lambda p: p.emit(I(UDIVI, 3, 1, 0))),
}
VHDL_ONLY = {"tick": p_tick}


def build(name, quick=False, seed=1):
    fn = PROGRAMS.get(name) or VHDL_ONLY[name]
    return fn(random.Random(f"{seed}-{name}"), quick)


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if "--list" in sys.argv:
        print(" ".join(list(PROGRAMS) + (list(VHDL_ONLY) if "--vhdl" in sys.argv else [])))
        sys.exit(0)
    prog = build(args[0], quick="--quick" in sys.argv)
    if "--boot" in sys.argv:                  # for run.sh: 1 if the program boots from flash
        print(int(prog.boot_flash))
        sys.exit(0)
    write_files(prog)
    print(f"{prog.name}: {len(prog.words)} instructions, {len(prog.expected)} results")
