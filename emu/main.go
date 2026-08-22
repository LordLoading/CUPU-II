package main

import "fmt"
import "os"
import "log"
import "emulator/hardware"

func main() {
	data, err := os.ReadFile("./test.bin")
	if err != nil {
		log.Fatal(err)
	}

	copy(hardware.Ram[0x0000:], data)

	fmt.Printf("%08x", hardware.ReadWord(0x0000))
}
