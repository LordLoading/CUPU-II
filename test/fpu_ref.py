"""Reference model for the FPU ops (func 0x0E..0x17), matching Go's float32 behaviour.

Python doubles give correctly rounded float32 +, -, *, /, sqrt when rounded once more
to float32 (53 >= 2*24 + 2). sin/cos/tan are float32(math.sin(float64(x))), like the
emulator. NaN bit patterns are not compared, only NaN-ness.
"""

import math
import struct

NAN = 0x7FC00000


def f2b(x):
    try:
        return struct.unpack("<I", struct.pack("<f", x))[0]
    except OverflowError:
        return 0x7F800000 if x > 0 else 0xFF800000


def b2f(b):
    return struct.unpack("<f", struct.pack("<I", b & 0xFFFFFFFF))[0]


def s32(x):
    x &= 0xFFFFFFFF
    return x - (1 << 32) if x & 0x80000000 else x


def go_round(x):
    """math.Round: half away from zero."""
    r = math.floor(abs(x) + 0.5)
    return -r if x < 0 else r


def fpu(op, a, b):
    """op = func11 - 0x0E. Returns the 32-bit result."""
    fa, fb = b2f(a), b2f(b)
    try:
        if op == 0:
            return f2b(float(s32(a)))
        if op == 1:
            if math.isnan(fa) or math.isinf(fa):
                return 0x80000000
            r = go_round(fa)
            return r & 0xFFFFFFFF if -(2**31) <= r < 2**31 else 0x80000000
        if op == 2:
            return f2b(fa + fb)
        if op == 3:
            return f2b(fa - fb)
        if op == 4:
            return f2b(fa * fb)
        if op == 5:
            if fb == 0:
                if fa == 0 or math.isnan(fa):
                    return NAN
                neg = (a ^ b) & 0x80000000
                return 0xFF800000 if neg else 0x7F800000
            return f2b(fa / fb)
        if op == 6:
            if fa == 0:
                return a
            return NAN if fa < 0 or math.isnan(fa) else f2b(math.sqrt(fa))
        if op in (7, 8, 9):
            if math.isnan(fa) or math.isinf(fa):
                return NAN
            return f2b((math.sin, math.cos, math.tan)[op - 7](fa))
    except (ValueError, OverflowError):
        return NAN
    raise ValueError(op)


def is_nan(b):
    return (b & 0x7F800000) == 0x7F800000 and (b & 0x7FFFFF) != 0


def ulps(x, y):
    """Distance in ulps between two float32 bit patterns."""
    def key(v):
        return v if v < 0x80000000 else 0x80000000 - v
    return abs(key(x) - key(y))


def matches(op, got, exp):
    """Exact, except NaN-ness only for NaNs and 1 ulp slack for sin/cos/tan."""
    if is_nan(exp):
        return is_nan(got)
    if op >= 7:
        return ulps(got, exp) <= 1
    return got == exp
