package tui

import (
	"emulator/hardware/cpu"
	"fmt"
)

func getState() string {
	return "PC: " + fmt.Sprintf("%08x", cpu.ProgramCounter) + "  IR: " + fmt.Sprintf("%08x", cpu.InstReg)
}
