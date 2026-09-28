package cpu

import (
	"emulator/hardware"
)

var Target uint32 = 0
var A uint32 = 0
var B uint32 = 0

var UsesA bool = false
var UsesB bool = false
var UsesT bool = false


func Tick() bool {
	InstReg = hardware.ReadWord(ProgramCounter)
	var IsCond = InstReg>>31 != 0
	var OpCode = (InstReg >> 26) & 0x1F
	Target = (InstReg >> 21) & 0x1F
	A = (InstReg >> 16) & 0x1F
	B = (InstReg >> 11) & 0x1F
	var Func11 = InstReg & 0x7FF
	var Imm = InstReg & 0x0FFFF
	if Imm&0x8000 != 0 {
		Imm |= 0xFFFF0000
	}

	if !(IsCond && !Cond) {
		UsesA = true
		UsesB = true
		UsesT = true

		if OpCode >= 0x08 && OpCode <= 0x0F {
			UsesB = false
		}

		switch OpCode {
		case 0x00:
			if Func11 <= 0x17 {
				WriteReg(Target, AutoOp(byte(Func11), ReadReg(A), ReadReg(B)))
			} else {
				if Func11 >= 0x20 && Func11 <= 0x25 {
					UsesT = false
				} else if Func11 >= 0x30 && Func11 <= 0x35 {
					UsesB = false
				}

				switch Func11 {
				case 0x20:
					Cond = ReadReg(A) == ReadReg(B)
				case 0x21:
					Cond = ReadReg(A) != ReadReg(B)
				case 0x22:
					Cond = ReadReg(A) > ReadReg(B)
				case 0x23:
					Cond = ReadReg(A) >= ReadReg(B)
				case 0x24:
					Cond = ReadReg(A) < ReadReg(B)
				case 0x25:
					Cond = ReadReg(A) <= ReadReg(B)
				case 0x30:
					WriteReg(Target, hardware.ReadWord(ReadReg(A)))
				case 0x31:
					WriteReg(Target, uint32(hardware.ReadHalfWord(ReadReg(A))))
				case 0x32:
					WriteReg(Target, uint32(hardware.ReadByte(ReadReg(A))))
				case 0x33:
					hardware.WriteWord(ReadReg(A), ReadReg(Target))
				case 0x34:
					hardware.WriteHalfWord(ReadReg(A), uint16(ReadReg(Target)))
				case 0x35:
					hardware.WriteByte(ReadReg(A), byte(ReadReg(Target)))
				case 0x40:
					UsesA = false
					UsesB = false
					UsesT = false
					return false
				}
			}
		case 0x08:
			WriteReg(Target, ReadReg(A)+Imm)
		case 0x09:
			WriteReg(Target, ReadReg(A)-Imm)
		case 0x0A:
			WriteReg(Target, ReadReg(A)*Imm)
		case 0x0B:
			WriteReg(Target, ReadReg(A)/Imm)
		case 0x0C:
			WriteReg(Target, ReadReg(A)|Imm)
		case 0x0D:
			WriteReg(Target, ReadReg(A)&Imm)
		case 0x0E:
			WriteReg(Target, ReadReg(A)^Imm)
		case 0x0F:
			WriteReg(Target, Imm<<16)
		case 0x10:
			WriteReg(Target, ProgramCounter+4)
			ProgramCounter = Imm + ReadReg(A)
			return true
		case 0x11:
			WriteReg(Target, ProgramCounter+4)
			ProgramCounter += Imm + ReadReg(A)
			return true
		case 0x18:
			WriteReg(Target, ReadReg(A)+Imm&0x0FFFF)
		case 0x19:
			WriteReg(Target, ReadReg(A)-Imm&0x0FFFF)
		case 0x1a:
			WriteReg(Target, ReadReg(A)*Imm&0x0FFFF)
		case 0x1b:
			WriteReg(Target, ReadReg(A)/Imm&0x0FFFF)
		case 0x1c:
			WriteReg(Target, ReadReg(A)|Imm&0x0FFFF)
		case 0x1d:
			WriteReg(Target, ReadReg(A)&Imm&0x0FFFF)
		case 0x1e:
			WriteReg(Target, ReadReg(A)^Imm&0x0FFFF)
		}
	}
	ProgramCounter += 4

	return true
}
