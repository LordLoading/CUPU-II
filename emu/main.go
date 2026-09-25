package main

import (
	"log"
	"os"

	"emulator/hardware"
	"emulator/tui"

	tea "github.com/charmbracelet/bubbletea"
)

func main() {
	data, err := os.ReadFile("./out.bin")
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	} else {
		copy(hardware.Ram[0x0000:], data)
	}

	m := tui.NewModel()
	p := tea.NewProgram(m)
	p.Run()
}
