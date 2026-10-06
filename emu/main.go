package main

import (
	"flag"
	"log"
	"os"

	"emulator/hardware"
	"emulator/hardware/mmio/devices/display"
	"emulator/tui"

	tea "github.com/charmbracelet/bubbletea"
)

var binPath = flag.String("bin", "out.bin", "path to binary file")
var clock = flag.Int("clk", 1e6, "clock speed in Hz")

func main() {
	flag.Parse()
	data, err := os.ReadFile(*binPath)
	display.Init()
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	} else {
		copy(hardware.Ram[0x0000:], data)
	}

	m := tui.NewModel((uint32)(*clock))
	p := tea.NewProgram(m, tea.WithAltScreen())
	p.Run()
}
