"""CUPU-II instruction encoders, a tiny program builder and the reference semantics.

Results are stored to the result area at RES (one word each). Every program ends
by writing DONE to gpio and halting; if the CPU runs past the halt it writes FAIL.

GPIO input protocol the testbenches follow:
  - during reset, ui_in = the boot strap (1: boot from the flash, else 0)
  - right after reset, ui_in = IN1
  - when gpio reads WAIT_IN, the program is polling the inputs: after a while, ui_in = IN2
"""

import os

M = 0xFFFFFFFF
RES = 0x100000
IN1 = 0xA6       # ui_in after reset
IN2 = 0x59       # ui_in once gpio reads WAIT_IN
WAIT_IN = 0x3C
DONE = 0xA5
FAIL = 0xEE
GPIO = 0x20000008
TIMESTAMP = 0x20000000
GPIN = 0x20000004   # ui_in, read only
FLASH = 0x01000000   # the flash is mapped here, read only; the testbenches load prog.hex into it


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
    0x00: lambda a, b: a + b,                                   # add
    0x01: lambda a, b: a - b,                                   # sub
    0x02: lambda a, b: s32(a) * s32(b),                         # mul
    0x03: lambda a, b: tdiv(s32(a), s32(b)),                    # div
    0x04: lambda a, b: a | b,                                   # or
    0x05: lambda a, b: a & b,                                   # and
    0x06: lambda a, b: a ^ b,                                   # xor
    0x07: lambda a, b: ~a,                                      # not
    0x08: lambda a, b: a << b if b < 32 else 0,                 # shl
    0x09: lambda a, b: a >> b if b < 32 else 0,                 # shr
    0x0A: lambda a, b: s32(a) - tdiv(s32(a), s32(b)) * s32(b),  # rem
    0x0B: lambda a, b: (s32(a) * s32(b)) >> 32,                 # mhi
    0x0C: lambda a, b: int(a + b + 1 > M),                      # ovrf
    0x0D: lambda a, b: int(a <= b),                             # unrf
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
    0x08: lambda a, i: a + sext16(i),              # addi
    0x09: lambda a, i: a - sext16(i),              # subi
    0x0A: lambda a, i: s32(a) * sext16(i),         # muli
    0x0B: lambda a, i: tdiv(s32(a), sext16(i)),    # divi
    0x0C: lambda a, i: a | (sext16(i) & M),        # ori
    0x0D: lambda a, i: a & (sext16(i) & M),        # andi
    0x0E: lambda a, i: a ^ (sext16(i) & M),        # xori
    0x18: lambda a, i: a + i,                      # uaddi
    0x19: lambda a, i: a - i,                      # usubi
    0x1A: lambda a, i: a * i,                      # umuli
    0x1B: lambda a, i: a // i,                     # udivi
    0x1C: lambda a, i: a | i,                      # uori
    0x1D: lambda a, i: a & i,                      # uandi
    0x1E: lambda a, i: a ^ i,                      # uxori
}

# func11 codes
LW, LH, LB, SW, SH, SB = 0x30, 0x31, 0x32, 0x33, 0x34, 0x35
HLT = 0x40
ADDI, SUBI, MULI, DIVI, ORI, ANDI, XORI, LUI, JAL, JRAL = 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11
UADDI, UORI, UDIVI = 0x18, 0x1C, 0x1B


def R(t, a, b, fn, cond=0):
    return (cond << 31) | (t << 21) | (a << 16) | (b << 11) | fn


def I(opc, t, a, imm, cond=0):
    return (cond << 31) | (opc << 26) | (t << 21) | (a << 16) | (imm & 0xFFFF)


class Prog:
    """A program under construction plus the results it must store."""

    PTR = 10  # result pointer register (programs that need r10 move it first)

    def __init__(self, name, ptr=10, base=0, boot_flash=False):
        self.name = name
        self.base = base              # address the program runs at (FLASH when booting from it)
        self.boot_flash = boot_flash  # ui_in(0) high during reset
        self.words = []
        self.expected = []   # (value, kind): kind -1 exact, else FPU op for fpu_ref.matches
        self.ptr = ptr
        self.li(ptr, RES)

    def emit(self, w):
        self.words.append(w & M)

    def pc(self):
        return self.base + 4 * len(self.words)

    def li(self, r, v):
        self.emit(I(LUI, r, 0, (v >> 16) & 0xFFFF))
        self.emit(I(UORI, r, r, v & 0xFFFF))

    def store_result(self, r, value, kind=-1):
        self.emit(R(r, self.ptr, 0, SW))         # sw r -> mem[ptr]
        self.emit(I(ADDI, self.ptr, self.ptr, 4))
        self.expected.append((value & M, kind))

    def gpio(self, v, tmp=(20, 21)):
        self.li(tmp[0], GPIO)
        self.li(tmp[1], v)
        self.emit(R(tmp[1], tmp[0], 0, SB))

    def finish(self, halt=None):
        """DONE to gpio, then halt (by default `hlt`); FAIL if execution continues."""
        self.gpio(DONE)
        if halt is None:
            self.emit(R(0, 0, 0, HLT))
        else:
            halt(self)
        self.gpio(FAIL)
        self.emit(R(0, 0, 0, HLT))
        assert 4 * len(self.words) < RES, "program overlaps result area"
        return self


def write_files(p, where="."):
    with open(os.path.join(where, "prog.hex"), "w") as f:
        f.writelines(f"{w:08x}\n" for w in p.words)
    with open(os.path.join(where, "expected.txt"), "w") as f:
        f.writelines(f"{v:08x} {k}\n" for v, k in p.expected)
