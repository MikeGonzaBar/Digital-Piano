# Verilog Piano for Basys 2

This project is a digital piano for the Digilent Basys 2 development board. It
uses the board's 50 MHz clock, seven switch positions, and four push buttons to
select one of 28 notes from C4 through DS6, then drives a square wave on the
`sound` output.

## What Changed Recently

The project has been repaired so it can be built and tested from source:

- `Piano.v` has been restored as the top-level module.
- `Piano.ucf` has been restored with Basys 2 pin assignments and a 50 MHz
  timing constraint.
- `Notes.v` now uses one synchronized note divider instead of muxing between
  many independent generated clocks.
- `sim/Piano_tb.v` verifies all note selections with HDL simulation.

## Repository Layout

- `Piano.v`: top-level Basys 2 module.
- `Bus.v`: maps physical switches/buttons into selection buses.
- `Notes.v`: synchronizes selections and generates the audio square wave.
- `Piano.ucf`: Basys 2 pin constraints and clock timing constraint.
- `sim/Piano_tb.v`: regression testbench for all notes and silence cases.
- `sim/iverilog.files`: source file list for Icarus Verilog.
- `docs/architecture.md`: design notes and signal flow.
- `docs/note-map.md`: switch/button note mapping.
- `docs/testing.md`: simulation and waveform inspection workflow.

Historical Xilinx generated files such as `.bit`, `.ngc`, `.ngd`, and `.ncd`
are still present, but rebuild the bitstream from source after making changes.

## Requirements

- Digilent Basys 2 board with a Spartan-3E FPGA
- Xilinx ISE 14.7 for synthesis, implementation, and bitstream generation
- Icarus Verilog for local simulation
- Optional: GTKWave or another VCD viewer for visual waveform inspection

## Build in Xilinx ISE

1. Open `PianoFinal.xise` in Xilinx ISE 14.7.
2. Confirm that `Piano.v` is the implementation top module.
3. Confirm that `Piano.ucf` is included as the user constraint file.
4. Run synthesis, implementation, and bitstream generation.
5. Program the generated bitstream onto the Basys 2 board.

## Run Simulation

From the repository root:

```powershell
iverilog -g2005 -o sim/Piano_tb.vvp -s Piano_tb -c sim/iverilog.files
vvp sim/Piano_tb.vvp
```

Expected result:

```text
ALL TESTS PASSED
```

The testbench checks all 28 valid note selections, verifies invalid selections
stay silent, and writes `sim/Piano_tb.vcd` for waveform inspection.

## Visual Inspection

After running the simulation, open the generated VCD file in a waveform viewer:

```powershell
gtkwave sim/Piano_tb.vcd
```

Useful signals to inspect are `sound`, `reset`, `swBus`, `noteBus`,
`selectedDivider`, `activeDivider`, and `counter`.

## Hardware Notes

The HDL simulation confirms digital behavior, but the final hardware check still
needs Xilinx ISE 14.7 and a Basys 2 board. Physical button bounce, speaker/load
behavior, and FPGA timing/resource reports are board/toolchain validation items.
