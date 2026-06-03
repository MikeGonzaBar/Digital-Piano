# Testing

## Behavioral Simulation

Run the regression testbench with Icarus Verilog:

```powershell
iverilog -g2005 -o sim/Piano_tb.vvp -s Piano_tb -c sim/iverilog.files
vvp sim/Piano_tb.vvp
```

The expected final line is:

```text
ALL TESTS PASSED
```

The testbench verifies:

- Reset drives `sound` low.
- Invalid selections stay silent.
- Changing notes resets the output phase.
- All 28 valid switch/button note combinations toggle at the expected divider
  interval.

## Waveform Inspection

The testbench writes `sim/Piano_tb.vcd`. Open it with GTKWave or another VCD
viewer:

```powershell
gtkwave sim/Piano_tb.vcd
```

Useful top-level signals:

- `clk`
- `reset`
- `sound`
- `sw1..sw7`
- `btn1..btn4`

Useful internal `Notes.v` signals:

- `swBusSync`
- `noteBusSync`
- `selectedDivider`
- `activeDivider`
- `counter`

## Hardware Validation

Simulation confirms digital behavior, but the board still needs a separate
hardware pass:

1. Rebuild the bitstream in Xilinx ISE 14.7.
2. Confirm the timing report includes the `TS_clk` 20 ns clock constraint.
3. Check FPGA resource usage after implementation.
4. Program the Basys 2 board.
5. Try valid and invalid switch/button combinations on the physical controls.
6. Listen for audible bounce or clicks during note changes.

If button bounce is audible, add a clocked debounce stage before the note
selection reaches `Notes.v`.
