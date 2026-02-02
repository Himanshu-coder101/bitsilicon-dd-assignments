---

## Tools Used

| Tool        | Purpose                          | Version (Example) |
|-------------|----------------------------------|-------------------|
| Ubuntu WSL  | Linux environment on Windows     | 22.04 LTS         |
| Icarus Verilog | RTL simulation and testing   | 11.0              |
| GTKWave     | Waveform viewer                  | 3.3.100           |
| Verilator   | RTL to C++ model generation      | 5.x               |
| GCC/G++     | C++ compiler                     | 11.x              |
| VS Code     | Code editor                      | Latest            |

(Note: Versions may vary depending on installation.)

---

## Design Description

### Hardware Design

The hardware is implemented using four synthesizable Verilog modules:

- `stopwatch_top.v` : Top-level module integrating all components
- `control_fsm.v`   : FSM implementing IDLE, RUNNING, and PAUSED states
- `seconds_counter.v` : Synchronous mod-60 seconds counter
- `minutes_counter.v` : Synchronous mod-100 minutes counter

All counters are synchronous. Ripple counters are not used.
Non-blocking assignments are used in all sequential blocks.

### FSM States

| Status | Meaning  |
|--------|----------|
| 00     | IDLE     |
| 01     | RUNNING  |
| 10     | PAUSED   |

---

### Software Design

The software component is implemented in `main.cpp` using Verilator.

The C++ program:

- Generates the clock signal
- Applies reset, start, stop, and resume commands
- Reads minutes and seconds outputs
- Displays time in MM:SS format

All timekeeping logic is implemented in hardware. The software only controls and observes
the design through the top-level interface.

---

## Build and Run Instructions

### 1. Hardware Verification (Icarus + GTKWave)

From the project root:

```bash
cd tb
iverilog ../rtl/*.v tb_stopwatch.v
vvp a.out
gtkwave wave.vcd
this is a readme file for my assignment give me another version of this file but keep the commands same