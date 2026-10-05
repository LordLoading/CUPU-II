package tui

import (
	"emulator/hardware/cpu"
	"emulator/hardware/mmio/devices/display"
	"emulator/hardware/mmio/devices/keyboard"
	"emulator/hardware/mmio/devices/term"
	"time"

	"github.com/charmbracelet/bubbles/table"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var cyclesSinceMeasurement uint32 = 0
var lastMeasurementTime time.Time = time.Now()
var clockSpeed uint32 = 0
var prevPC uint32 = 0

type model struct {
	regTable table.Model
}

type frameMsg struct{}

func NewModel(targetFreq uint32) model {
	runCPU(targetFreq)
	return model{
		// model: regTables,
	}
}

var box = lipgloss.NewStyle().Border(lipgloss.RoundedBorder()).Padding(0, 1)

func runCPU(targetFreq uint32) {
	go func() {
		ticker := time.NewTicker(time.Second / time.Duration(targetFreq))
		defer ticker.Stop()
		for {
			select {
			case <-ticker.C:
				prevPC = cpu.ProgramCounter
				cpu.Tick()
				cyclesSinceMeasurement += 1
			}
		}
	}()
}

func (m model) Init() tea.Cmd {
	regs1.SetCursor(-1)
	regs2.SetCursor(-1)
	styles := table.DefaultStyles()
	styles.Selected = lipgloss.NewStyle()
	regs1.SetStyles(styles)
	regs2.SetStyles(styles)
	return tea.Tick(16*time.Millisecond, func(time.Time) tea.Msg { return frameMsg{} })
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	if keyMsg, ok := msg.(tea.KeyMsg); ok {
		switch keyMsg.String() {
		case "ctrl+c":
			return m, tea.Quit
		case "enter":
			keyboard.WriteByte(byte('\n'))
			return m, nil
		case "backspace":
			keyboard.WriteByte(byte('\b'))
			return m, nil
		default:
			keyboard.WriteByte(byte(keyMsg.Runes[0]))
			return m, nil
		}
	}

	switch msg.(type) {
	case frameMsg:
		regs = buildRegRows()
		regs1.SetRows(regs[0])
		regs2.SetRows(regs[1])

		sinceLastMeasurement := time.Since(lastMeasurementTime)
		if time.Duration(sinceLastMeasurement.Seconds()) > 1 {
			clockSpeed = cyclesSinceMeasurement / uint32(sinceLastMeasurement.Seconds())
			lastMeasurementTime = time.Now()
			cyclesSinceMeasurement = 0
		}

		return m, tea.Tick(16*time.Millisecond, func(time.Time) tea.Msg { return frameMsg{} })
	}

	return m, nil
}

func (m model) View() string {
	display.View()
	return lipgloss.JoinHorizontal(lipgloss.Top,
		lipgloss.JoinVertical(lipgloss.Top,
			getInfo(),
			lipgloss.JoinHorizontal(lipgloss.Top,
				box.Render(lipgloss.JoinHorizontal(lipgloss.Top,
					regs1.View(), regs2.View())),
				box.Render(buildRamTable()))),
		lipgloss.JoinVertical(lipgloss.Top,
			"keyboard buffer:"+keyboard.View(),
			box.Render("Term\n" + term.View())))
}
