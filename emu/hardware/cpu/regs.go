package cpu

var Regs [32]uint32

func ReadReg(reg uint32) uint32 {
	if reg == 0 {
		return 0
	}
	return Regs[reg]
}

func WriteReg(reg uint32, value uint32) {
	if reg == 0 {
		return
	}
	Regs[reg] = value
}

var InstReg uint32
var ProgramCounter uint32
var AddressReg uint32
var cond bool
