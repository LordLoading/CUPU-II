package cpu

import "math"
import "math/bits"

func AutoOp(opCode byte, a uint32, b uint32) uint32 {
	switch opCode {
	case 0x00:
		return a + b
	case 0x01:
		return a - b
	case 0x02:
		return uint32(int32(a) * int32(b))
	case 0x03:
		return uint32(int32(a) / int32(b))
	case 0x04:
		return a | b
	case 0x05:
		return a & b
	case 0x06:
		return a ^ b
	case 0x07:
		return ^a
	case 0x08:
		return a << b
	case 0x09:
		return a >> b
	case 0x0A:
		return uint32(int32(a) % int32(b))
	case 0x0B:
		return uint32((int64(int32(a)) * int64(int32(b))) >> 32)
	case 0x0C:
		_, carry := bits.Add32(a, b, 1)
		return carry
	case 0x0D:
		_, borrow := bits.Sub32(a, b, 1)
		return borrow

	// fpu ops are here as well for convenience
	// both for the emulator and the cpu
	case 0x0E:
		return fasi(float32(int32(a)))
	case 0x0F:
		return uint32(int32(math.Round(float64(iasf(a)))))
	case 0x10:
		return fasi(iasf(a) + iasf(b))
	case 0x11:
		return fasi(iasf(a) - iasf(b))
	case 0x12:
		return fasi(iasf(a) * iasf(b))
	case 0x13:
		return fasi(iasf(a) / iasf(b))
	case 0x14:
		return fasi(float32(math.Sqrt(float64(iasf(a)))))
	case 0x15:
		return fasi(float32(math.Sin(float64(iasf(a)))))
	case 0x16:
		return fasi(float32(math.Cos(float64(iasf(a)))))
	case 0x17:
		return fasi(float32(math.Tan(float64(iasf(a)))))
	default:
		return 0
	}
}

func iasf(i uint32) float32 {
	return math.Float32frombits(i)
}

func fasi(f float32) uint32 {
	return math.Float32bits(f)
}
