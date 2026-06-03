`timescale 1ns / 1ps

// Converts a one-hot switch/button selection into a square-wave note output.
// The Basys 2 clock is 50 MHz. The divider constants come from the original
// design's integer note frequencies, and each output transition occurs after
// the selected threshold is reached.
module Notes(
	input clk,
	input reset,
	input [6:0] swBus,
	input [3:0] noteBus,
	output reg clkNote
	);

	localparam [24:0] DIV_DS6 = 25000000 / 1245;
	localparam [24:0] DIV_D6  = 25000000 / 1175;
	localparam [24:0] DIV_CS6 = 25000000 / 1109;
	localparam [24:0] DIV_C6  = 25000000 / 1047;
	localparam [24:0] DIV_B5  = 25000000 / 988;
	localparam [24:0] DIV_AS5 = 25000000 / 932;
	localparam [24:0] DIV_A5  = 25000000 / 880;
	localparam [24:0] DIV_GS5 = 25000000 / 830;
	localparam [24:0] DIV_G5  = 25000000 / 784;
	localparam [24:0] DIV_FS5 = 25000000 / 740;
	localparam [24:0] DIV_F5  = 25000000 / 698;
	localparam [24:0] DIV_E5  = 25000000 / 659;
	localparam [24:0] DIV_DS5 = 25000000 / 622;
	localparam [24:0] DIV_D5  = 25000000 / 587;
	localparam [24:0] DIV_CS5 = 25000000 / 554;
	localparam [24:0] DIV_C5  = 25000000 / 523;
	localparam [24:0] DIV_B4  = 25000000 / 494;
	localparam [24:0] DIV_AS4 = 25000000 / 466;
	localparam [24:0] DIV_A4  = 25000000 / 440;
	localparam [24:0] DIV_GS4 = 25000000 / 415;
	localparam [24:0] DIV_G4  = 25000000 / 392;
	localparam [24:0] DIV_FS4 = 25000000 / 370;
	localparam [24:0] DIV_F4  = 25000000 / 349;
	localparam [24:0] DIV_E4  = 25000000 / 330;
	localparam [24:0] DIV_DS4 = 25000000 / 311;
	localparam [24:0] DIV_D4  = 25000000 / 294;
	localparam [24:0] DIV_CS4 = 25000000 / 277;
	localparam [24:0] DIV_C4  = 25000000 / 262;

	reg [6:0] swBusMeta;
	reg [6:0] swBusSync;
	reg [3:0] noteBusMeta;
	reg [3:0] noteBusSync;
	reg [24:0] selectedDivider;
	reg [24:0] activeDivider;
	reg [24:0] counter;

	// Only one switch and one button should be selected. Any other combination
	// maps to divider 0, which holds the output silent.
	always @(*) begin
		case ({swBusSync, noteBusSync})
			{7'd1, 4'd1}:  selectedDivider = DIV_DS6;
			{7'd1, 4'd2}:  selectedDivider = DIV_D6;
			{7'd1, 4'd4}:  selectedDivider = DIV_CS6;
			{7'd1, 4'd8}:  selectedDivider = DIV_C6;
			{7'd2, 4'd1}:  selectedDivider = DIV_B5;
			{7'd2, 4'd2}:  selectedDivider = DIV_AS5;
			{7'd2, 4'd4}:  selectedDivider = DIV_A5;
			{7'd2, 4'd8}:  selectedDivider = DIV_GS5;
			{7'd4, 4'd1}:  selectedDivider = DIV_G5;
			{7'd4, 4'd2}:  selectedDivider = DIV_FS5;
			{7'd4, 4'd4}:  selectedDivider = DIV_F5;
			{7'd4, 4'd8}:  selectedDivider = DIV_E5;
			{7'd8, 4'd1}:  selectedDivider = DIV_DS5;
			{7'd8, 4'd2}:  selectedDivider = DIV_D5;
			{7'd8, 4'd4}:  selectedDivider = DIV_CS5;
			{7'd8, 4'd8}:  selectedDivider = DIV_C5;
			{7'd16, 4'd1}: selectedDivider = DIV_B4;
			{7'd16, 4'd2}: selectedDivider = DIV_AS4;
			{7'd16, 4'd4}: selectedDivider = DIV_A4;
			{7'd16, 4'd8}: selectedDivider = DIV_GS4;
			{7'd32, 4'd1}: selectedDivider = DIV_G4;
			{7'd32, 4'd2}: selectedDivider = DIV_FS4;
			{7'd32, 4'd4}: selectedDivider = DIV_F4;
			{7'd32, 4'd8}: selectedDivider = DIV_E4;
			{7'd64, 4'd1}: selectedDivider = DIV_DS4;
			{7'd64, 4'd2}: selectedDivider = DIV_D4;
			{7'd64, 4'd4}: selectedDivider = DIV_CS4;
			{7'd64, 4'd8}: selectedDivider = DIV_C4;
			default:        selectedDivider = 25'd0;
		endcase
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			swBusMeta <= 7'd0;
			swBusSync <= 7'd0;
			noteBusMeta <= 4'd0;
			noteBusSync <= 4'd0;
			activeDivider <= 25'd0;
			counter <= 25'd0;
			clkNote <= 1'b0;
		end else begin
			// Two-stage synchronizers reduce metastability risk from the board
			// switches/buttons before they affect the divider.
			swBusMeta <= swBus;
			swBusSync <= swBusMeta;
			noteBusMeta <= noteBus;
			noteBusSync <= noteBusMeta;

			if (selectedDivider == 25'd0) begin
				activeDivider <= 25'd0;
				counter <= 25'd0;
				clkNote <= 1'b0;
			end else if (selectedDivider != activeDivider) begin
				// Start every new note from a known low phase to avoid selecting
				// between unrelated square-wave clocks.
				activeDivider <= selectedDivider;
				counter <= 25'd0;
				clkNote <= 1'b0;
			end else if (counter >= selectedDivider) begin
				counter <= 25'd0;
				clkNote <= ~clkNote;
			end else begin
				counter <= counter + 25'd1;
			end
		end
	end

endmodule
