package cpu

import (
	"emulator/hardware"
)

func Tick() {
	InstReg = hardware.ReadWord(ProgramCounter)
}
