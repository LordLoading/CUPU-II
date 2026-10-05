package display

import (
	"image/color"

	rl "github.com/gen2brain/raylib-go/raylib"
)

const BaseAddr uint32 = 0x20010000
const Size uint32 = 3 * 256 * 256

var DisplayBufferR [Size / 3]byte
var DisplayBufferG [Size / 3]byte
var DisplayBufferB [Size / 3]byte

func WriteByte(addr uint32, value byte) {
	if addr >= BaseAddr && addr < BaseAddr+Size {
		switch addr % 3 {
		case 0:
			DisplayBufferR[addr/3] = value
		case 1:
			DisplayBufferG[addr/3] = value
		case 2:
			DisplayBufferB[addr/3] = value
		}
	}
}

func Init() {
	rl.InitWindow(512, 512, "display")
}

func View() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.Black)
	for i := range 255 {
		for j := range 255 {
			rl.DrawPixel((int32)(j), (int32)(i), color.RGBA{DisplayBufferR[i*256+j], DisplayBufferG[i*256+j], DisplayBufferB[i*256+j], 255})
		}
	}
	rl.EndDrawing()
}
