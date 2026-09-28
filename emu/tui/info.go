package tui

import (
	"emulator/hardware/cpu"
	"fmt"
)

func getInfo() string {
	return "PC: " + fmt.Sprintf("%08x", cpu.ProgramCounter) + "  IR: " + fmt.Sprintf("%08x", cpu.InstReg) + "  clk: " + fmt.Sprintf("%d", clockSpeed) + "Hz"
}
