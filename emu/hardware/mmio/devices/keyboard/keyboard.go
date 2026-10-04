package keyboard

const BaseAddr uint32 = 0x20000004
const Size uint32 = 1

var Buffer = make([]byte, 32)
var end byte = 0

func WriteByte(b byte) {
	Buffer[end%32] = b
	end++
}

func ReadByte(addr uint32) byte {
	if addr == BaseAddr {
		end--
		b := Buffer[end%32]
		Buffer[end%32] = 0
		return b
	}
	return 0
}

func View() string {
	var str = ""
	for i, _ := range Buffer {
		str += string(Buffer[((byte)(i)+end)%32])
	}
	return str
}
