package cpu

import (
	"emulator/hardware"
)

func Tick() bool {
	InstReg = hardware.ReadWord(ProgramCounter)
	var IsCond = InstReg>>31 != 0
	var OpCode = (InstReg >> 26) & 0x1F
	var Target = (InstReg >> 21) & 0x1F
	var A = (InstReg >> 16) & 0x1F
	var B = (InstReg >> 11) & 0x1F
	var Func11 = InstReg & 0x7FF
	var Imm = InstReg & 0x0FFFF
	if Imm&0x8000 != 0 {
		Imm |= 0xFFFF0000
	}

	if !(IsCond && !Cond) {
		switch OpCode {
		case 0x00:
			if Func11 <= 0x17 {
				WriteReg(Target, AutoOp(byte(Func11), ReadReg(A), ReadReg(B)))
			} else {
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
					WriteReg(Target, hardware.ReadWord(ReadReg(A)+Imm))
				case 0x31:
					WriteReg(Target, uint32(hardware.ReadHalfWord(ReadReg(A)+Imm)))
				case 0x32:
					WriteReg(Target, uint32(hardware.ReadByte(ReadReg(A)+Imm)))
				case 0x33:
					hardware.WriteWord(ReadReg(A)+Imm, ReadReg(Target))
				case 0x34:
					hardware.WriteHalfWord(ReadReg(A)+Imm, uint16(ReadReg(Target)))
				case 0x35:
					hardware.WriteByte(ReadReg(A)+Imm, byte(ReadReg(Target)))
				case 0x40:
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
