package hardware

import "emulator/hardware/mmio"

var Ram [0x1000000]byte

func ReadByte(addr uint32) byte {
	if addr >= (uint32(len(Ram))) {
		return mmio.MMIOReadByte(addr)
	}
	return Ram[addr]
}

func WriteByte(addr uint32, value byte) {
	if addr >= (uint32(len(Ram))) {
		mmio.MMIOWriteByte(addr, value)
		return
	}
	Ram[addr] = value
}

func ReadHalfWord(addr uint32) uint16 {
	return uint16(ReadByte(addr)) | uint16(ReadByte(addr+1))<<8
}

func WriteHalfWord(addr uint32, value uint16) {
	WriteByte(addr, byte(value))
	WriteByte(addr+1, byte(value>>8))
}

func ReadWord(addr uint32) uint32 {
	return uint32(ReadByte(addr)) | uint32(ReadByte(addr+1))<<8 | uint32(ReadByte(addr+2))<<16 | uint32(ReadByte(addr+3))<<24
}

func WriteWord(addr uint32, value uint32) {
	WriteByte(addr, byte(value))
	WriteByte(addr+1, byte(value>>8))
	WriteByte(addr+2, byte(value>>16))
	WriteByte(addr+3, byte(value>>24))
}
