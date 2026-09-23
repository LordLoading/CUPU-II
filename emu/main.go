package main

import (
	"fmt"
	"log"
	"os"

	"emulator/hardware"
	"emulator/tui"

	// tea "github.com/charmbracelet/bubbletea"
)

func main() {
	data, err := os.ReadFile("./test.bin")
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	} else {
		copy(hardware.Ram[0x0000:], data)
	}

	if err := tui.Run(); err != nil {
		fmt.Println("Error running program:", err)
		os.Exit(1)
	}	
}
