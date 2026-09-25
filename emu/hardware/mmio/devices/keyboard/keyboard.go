package keyboard

const BaseAddr uint32 = 0x20000004
const Size uint32 = 1

var Buffer = make(chan byte, 32)

func KeyboardReadByte(addr uint32) byte {
	if addr == BaseAddr {
		return <-Buffer
	}
	return 0
}
