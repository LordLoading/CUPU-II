package term

import "strings"

const BaseAddr uint32 = 0x20000004
const Size uint32 = 1

var DisplayBuffer [16][32]byte
var endY byte = 0
var endX byte = 0

func WriteByte(addr uint32, b byte) {
	if addr != BaseAddr {
		return
	}

	switch b {
	case 0:
		return
	case '\n':
		endX = 0
		endY++
		DisplayBuffer[endY%16] = [32]byte{}
	case '\b':
		if endX > 0 {
			endX--
		}
		DisplayBuffer[endY%16][endX%32] = 0
	default:
		if endX >= 32 {
			endX = 0
			endY++
			DisplayBuffer[endY%16] = [32]byte{b}
		} else {
			DisplayBuffer[endY%16][endX%32] = b
			endX++
		}
	}
}

func View() string {
	var str strings.Builder
	for i, _ := range DisplayBuffer {
		str.WriteString(strings.Replace(string(DisplayBuffer[((byte)(i)+endY + 1)%16][:]), "\x00", " ", -1))
		if i != 15 {
			str.WriteByte('\n')
		}
	}
	return str.String()
}
