# Verilog Piano for Basys 2
This is a digital piano program written in Verilog for the Basys 2 development board. The program uses the frequency of the clock and the configuration of the 4 buttons and 8 switches to determine which note and octave should be played. The range of the octaves goes from the 4th to the 6th octave.

## Features
- 4 buttons for selecting different notes
- 8 switches for selecting different octaves
- Dynamic selection of notes and octaves based on button and switch configuration
- Range of 4th to 6th octaves


## Prerequisites
- Basys 2 development board
- Xilinx Vivado Design Suite
- Verilog compiler

## Usage
1. Open Xilinx Vivado Design Suite and create a new project.
2. Add the Verilog code from this repository to the project.
3. Synthesize and implement the design.
4. Generate the bitstream file.
5. Download the bitstream file to the Basys 2 development board.
6. Use the buttons and switches to select different notes and octaves.
