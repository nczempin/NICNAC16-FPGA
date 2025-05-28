`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:08:32 09/25/2014 
// Design Name: 
// Module Name:    select1of4_16 
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
module select1of4_16(
    input [15:0] A,
    input [15:0] B,
    input [15:0] C,
    input [15:0] D,
    input SEL_A,
    input SEL_B,
    input SEL_C,
    input SEL_D,
    output reg [15:0] OUT
    );

always  @ (A or B or C or D or SEL_A or SEL_B or SEL_C or SEL_D) begin
	// when (what shouldn't really happen; TODO how do I "assert" invalid conditions?) more than one is selected, take the "earliest" one.
	if (SEL_A) OUT = A;
	else if (SEL_B) OUT = B;
	else if (SEL_C) OUT = C;
	else if (SEL_D) OUT = D;
	else OUT = 16'h0000;
	
end

endmodule
