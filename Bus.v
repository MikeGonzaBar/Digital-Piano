`timescale 1ns / 1ps

// Packs the physical Basys 2 switches and push buttons into compact selection
// buses. The bit order matches the original note map used by Notes.v.
module Bus(
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
	output [6:0] swBus,
	output [3:0] noteBus
	);
	
	assign swBus[0] = sw7;
	assign swBus[1] = sw6;
	assign swBus[2] = sw5;
	assign swBus[3] = sw4;
	assign swBus[4] = sw3;
	assign swBus[5] = sw2;
	assign swBus[6] = sw1;
	
	assign noteBus[0] = btn4;
	assign noteBus[1] = btn3;
	assign noteBus[2] = btn2;
	assign noteBus[3] = btn1;
	
endmodule

