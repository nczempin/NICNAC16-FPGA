`timescale 1ns / 1ps
module mux16_2 (A, B, SEL, OUT);

	input [15:0] A;
	input [15:0] B;
	input SEL;
	output [15:0] OUT;

	assign OUT = SEL == 1'b0 ? A : B;

endmodule
