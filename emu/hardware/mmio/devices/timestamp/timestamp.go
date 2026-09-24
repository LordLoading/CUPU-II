package timestamp

import "time"

const BaseAddr uint32 = 0x20000002
const Size uint32 = 4

func TimestampReadByte(addr uint32) byte {
	if addr == BaseAddr {
		return byte(time.Now().Unix())
	} else if addr == BaseAddr+1 {
		return byte(time.Now().Unix() >> 8)
	} else if addr == BaseAddr+2 {
		return byte(time.Now().Unix() >> 16)
	} else if addr == BaseAddr+3 {
		return byte(time.Now().Unix() >> 24)
	}
	return 0
}
