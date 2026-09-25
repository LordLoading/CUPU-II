package mmio

import (
	"emulator/hardware/mmio/devices/keyboard"
	"emulator/hardware/mmio/devices/timestamp"
)

func MMIOReadByte(addr uint32) byte {
	if addr >= timestamp.BaseAddr && addr < timestamp.BaseAddr+timestamp.Size {
		return timestamp.TimestampReadByte(addr)
	}
	if addr >= keyboard.BaseAddr && addr < keyboard.BaseAddr+keyboard.Size {
		return keyboard.KeyboardReadByte(addr)
	}
	return 0
}

func MMIOWriteByte(addr uint32, value byte) {
}

func Tick() {}
