`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:17 05/07/2020 
// Design Name: 
// Module Name:    Notes 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Notes(
	input clk,
	input reset,
	input [6:0] swBus,
	input [3:0] noteBus,
	output clkNote
	);

	wire notaC4, notaC5, notaC6, notaCS4, notaCS5, notaCS6, notaD4, notaD5,
	notaD6, notaDS4, notaDS5, notaDS6, notaE4, notaE5, notaF4, notaF5, notaFS4,
	notaFS5, notaG4, notaG5, notaGS4, notaGS5, notaA4, notaA5, notaAS4, notaAS5,
	notaB4, notaB5;
	
	NoteC4	 	NoteC4	(.clk(clk),.reset(reset),.ClkRedu(	notaC4	));
	NoteC5	 	NoteC5	(.clk(clk),.reset(reset),.ClkRedu(	notaC5	));
	NoteC6	 	NoteC6	(.clk(clk),.reset(reset),.ClkRedu(	notaC6	));
	NoteCS4	 	NoteCS4	(.clk(clk),.reset(reset),.ClkRedu(	notaCS4	));
	NoteCS5	 	NoteCS5	(.clk(clk),.reset(reset),.ClkRedu(	notaCS5	));
	NoteCS6	 	NoteCS6	(.clk(clk),.reset(reset),.ClkRedu(	notaCS6	));
	NoteD4	 	NoteD4	(.clk(clk),.reset(reset),.ClkRedu(	notaD4	));
	NoteD5	 	NoteD5	(.clk(clk),.reset(reset),.ClkRedu(	notaD5	));
	NoteD6	 	NoteD6	(.clk(clk),.reset(reset),.ClkRedu(	notaD6	));
	NoteDS4	 	NoteDS4	(.clk(clk),.reset(reset),.ClkRedu(	notaDS4	));
	NoteDS5	 	NoteDS5	(.clk(clk),.reset(reset),.ClkRedu(	notaDS5	));
	NoteDS6	 	NoteDS6	(.clk(clk),.reset(reset),.ClkRedu(	notaDS6	));
	NoteE4	 	NoteE4	(.clk(clk),.reset(reset),.ClkRedu(	notaE4	));
	NoteE5	 	NoteE5	(.clk(clk),.reset(reset),.ClkRedu(	notaE5	));
	NoteF4	 	NoteF4	(.clk(clk),.reset(reset),.ClkRedu(	notaF4	));
	NoteF5	 	NoteF5	(.clk(clk),.reset(reset),.ClkRedu(	notaF5	));
	NoteFS4	 	NoteFS4	(.clk(clk),.reset(reset),.ClkRedu(	notaFS4	));
	NoteFS5	 	NoteFS5	(.clk(clk),.reset(reset),.ClkRedu(	notaFS5	));
	NoteG4	 	NoteG4	(.clk(clk),.reset(reset),.ClkRedu(	notaG4	));
	NoteG5	 	NoteG5	(.clk(clk),.reset(reset),.ClkRedu(	notaG5	));
	NoteGS4	 	NoteGS4	(.clk(clk),.reset(reset),.ClkRedu(	notaGS4	));
	NoteGS5	 	NoteGS5	(.clk(clk),.reset(reset),.ClkRedu(	notaGS5	));
	NoteA4	 	NoteA4	(.clk(clk),.reset(reset),.ClkRedu(	notaA4	));
	NoteA5	 	NoteA5	(.clk(clk),.reset(reset),.ClkRedu(	notaA5	));
	NoteAS4	 	NoteAS4	(.clk(clk),.reset(reset),.ClkRedu(	notaAS4	));
	NoteAS5	 	NoteAS5	(.clk(clk),.reset(reset),.ClkRedu(	notaAS5	));
	NoteB4	 	NoteB4	(.clk(clk),.reset(reset),.ClkRedu(	notaB4	));
	NoteB5	 	NoteB5	(.clk(clk),.reset(reset),.ClkRedu(	notaB5	));



	
	assign clkNote  =
	(swBus == 	1	 && noteBus == 	1	) ? 	notaDS6	:
	(swBus == 	1	 && noteBus == 	2	) ? 	notaD6	:
	(swBus == 	1	 && noteBus == 	4	) ? 	notaCS6	:
	(swBus == 	1	 && noteBus == 	8	) ? 	notaC6	:
	(swBus == 	2	 && noteBus == 	1	) ? 	notaB5	:
	(swBus == 	2	 && noteBus == 	2	) ? 	notaAS5	:
	(swBus == 	2	 && noteBus == 	4	) ? 	notaA5	:
	(swBus == 	2	 && noteBus == 	8	) ? 	notaGS5	:
	(swBus == 	4	 && noteBus == 	1	) ? 	notaG5	:
	(swBus == 	4	 && noteBus == 	2	) ? 	notaFS5	:
	(swBus == 	4	 && noteBus == 	4	) ? 	notaF5	:
	(swBus == 	4	 && noteBus == 	8	) ? 	notaE5	:
	(swBus == 	8	 && noteBus == 	1	) ? 	notaDS5	:
	(swBus == 	8	 && noteBus == 	2	) ? 	notaD5	:
	(swBus == 	8	 && noteBus == 	4	) ? 	notaCS5	:
	(swBus == 	8	 && noteBus == 	8	) ? 	notaC5	:
	(swBus == 	16	 && noteBus == 	1	) ? 	notaB4	:
	(swBus == 	16	 && noteBus == 	2	) ? 	notaAS4	:
	(swBus == 	16	 && noteBus == 	4	) ? 	notaA4	:
	(swBus == 	16	 && noteBus == 	8	) ? 	notaGS4	:
	(swBus == 	32	 && noteBus == 	1	) ? 	notaG4	:
	(swBus == 	32	 && noteBus == 	2	) ? 	notaFS4	:
	(swBus == 	32	 && noteBus == 	4	) ? 	notaF4	:
	(swBus == 	32	 && noteBus == 	8	) ? 	notaE4	:
	(swBus == 	64	 && noteBus == 	1	) ? 	notaDS4	:
	(swBus == 	64	 && noteBus == 	2	) ? 	notaD4	:
	(swBus == 	64	 && noteBus == 	4	) ? 	notaCS4	:
	(swBus == 	64	 && noteBus == 	8	) ? 	notaC4	:
															0			;
	
endmodule

