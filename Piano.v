`timescale 1ns / 1ps

// Top-level Basys 2 digital piano design.
// The individual board inputs are first packed into buses, then passed to the
// note generator that drives the square-wave audio output.
module Piano(
	input clk,
	input reset,
	input sw1,
	input sw2,
	input sw3,
	input sw4,
	input sw5,
	input sw6,
	input sw7,
	input btn1,
	input btn2,
	input btn3,
	input btn4,
	output sound
	);

	wire [6:0] swBus;
	wire [3:0] noteBus;

	Bus inputBus(
		.sw1(sw1),
		.sw2(sw2),
		.sw3(sw3),
		.sw4(sw4),
		.sw5(sw5),
		.sw6(sw6),
		.sw7(sw7),
		.btn1(btn1),
		.btn2(btn2),
		.btn3(btn3),
		.btn4(btn4),
		.swBus(swBus),
		.noteBus(noteBus)
	);

	Notes noteGenerator(
		.clk(clk),
		.reset(reset),
		.swBus(swBus),
		.noteBus(noteBus),
		.clkNote(sound)
	);

endmodule
