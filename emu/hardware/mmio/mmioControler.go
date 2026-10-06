package mmio

import (
	"emulator/hardware/mmio/devices/display"
	"emulator/hardware/mmio/devices/keyboard"
	"emulator/hardware/mmio/devices/term"
	"emulator/hardware/mmio/devices/timestamp"
)

func MMIOReadByte(addr uint32) byte {
	if addr >= timestamp.BaseAddr && addr < timestamp.BaseAddr+timestamp.Size {
		return timestamp.ReadByte(addr)
	}
	if addr >= keyboard.BaseAddr && addr < keyboard.BaseAddr+keyboard.Size {
		return keyboard.ReadByte(addr)
	}
	return 0
}

func MMIOWriteByte(addr uint32, value byte) {
	if addr >= term.BaseAddr && addr < term.BaseAddr+term.Size {
		term.WriteByte(addr, value)
	}
	if addr >= display.BaseAddr && addr < display.BaseAddr+display.Size {
		display.WriteByte(addr, value)
	}
}

func Tick() {}
