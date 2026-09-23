package hardware

var Ram [0x1000000]byte

func ReadByte(addr uint32) byte {
    return Ram[addr]
}

func WriteByte(addr uint32, value byte) {
    Ram[addr] = value
}

func ReadHalfWord(addr uint32) uint16 {
	return uint16(Ram[addr]) | uint16(Ram[addr+1])<<8
}

func WriteHalfWord(addr uint32, value uint16) {
	Ram[addr] = byte(value)
	Ram[addr+1] = byte(value >> 8)
}

func ReadWord(addr uint32) uint32 {
	return uint32(Ram[addr]) | uint32(Ram[addr+1])<<8 | uint32(Ram[addr+2])<<16 | uint32(Ram[addr+3])<<24
}

func WriteWord(addr uint32, value uint32) {
	Ram[addr] = byte(value)
	Ram[addr+1] = byte(value >> 8)
	Ram[addr+2] = byte(value >> 16)
	Ram[addr+3] = byte(value >> 24)
}
