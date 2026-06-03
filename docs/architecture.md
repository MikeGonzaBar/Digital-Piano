# Architecture

## Signal Flow

```text
Basys 2 switches/buttons
        |
        v
      Bus.v
        |
        | swBus[6:0], noteBus[3:0]
        v
      Notes.v
        |
        | clkNote
        v
      sound
```

## Modules

`Piano.v` is the top-level module. It wires the physical board pins into
`Bus.v`, then sends the packed switch and button buses into `Notes.v`.

`Bus.v` preserves the original hardware mapping:

- `sw1..sw7` become a 7-bit one-hot `swBus`.
- `btn1..btn4` become a 4-bit one-hot `noteBus`.

`Notes.v` contains the note lookup table, input synchronizers, and one counter
used to generate the output square wave.

## Note Generation

The Basys 2 clock is 50 MHz. The design toggles `clkNote` after the selected
divider threshold is reached. Since one full square-wave cycle takes two output
toggles, the output frequency is approximately:

```text
frequency = 50_000_000 / (2 * (divider + 1))
```

The divider constants are based on the original project's integer note
frequencies, for example:

```verilog
localparam [24:0] DIV_A4 = 25000000 / 440;
```

## Input Handling

Switch and button buses pass through two clocked stages before they select a
divider. This reduces metastability risk from asynchronous board inputs.

The design expects exactly one switch and exactly one button to be active. Any
other combination selects divider `0`, resets the counter, and holds `sound`
low.

The design does not currently debounce mechanical inputs. A bouncing button may
restart the current note briefly on real hardware. Add a debouncer before
`Bus.v` or inside `Notes.v` if that becomes audible on the board.

## Why One Divider

The original implementation instantiated one divider module per note and then
muxed between generated clock-like waveforms. The current design selects a
divider value and generates one square wave from one counter. This keeps the
output phase deterministic when notes change and uses fewer FPGA resources.
