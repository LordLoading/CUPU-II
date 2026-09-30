package main

import (
	"flag"
	"log"
	"os"

	"emulator/hardware"
	"emulator/tui"

	tea "github.com/charmbracelet/bubbletea"
)

var binPath = flag.String("bin", "out.bin", "path to binary file")
var clockSpeed = flag.Int("clk", 1e6, "clock speed in Hz")

func main() {
	flag.Parse()
	data, err := os.ReadFile(*binPath)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	} else {
		copy(hardware.Ram[0x0000:], data)
	}

	m := tui.NewModel()
	p := tea.NewProgram(m, tea.WithAltScreen())
	p.Run()
}
