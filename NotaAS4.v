`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:37:31 03/25/2020 
// Design Name: 
// Module Name:    ClkRedu 
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
module NoteAS4(
    input clk,
    input reset,
    output reg ClkRedu // Puerto A, PIN 1 - B2
    );

	reg [24:0] conteo; //0 a 25M
	
	
	always @ (posedge clk, posedge reset)
		begin
		if(reset)
			begin
				conteo <= 0;
				ClkRedu <= 0;
			end
		else
			begin
				conteo <= conteo + 1;
			if(conteo == 25000000/466) 
				begin
					ClkRedu <= ClkRedu + 1;
					conteo <= 0;
				end
			end
		end

endmodule
