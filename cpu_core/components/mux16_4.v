`timescale 1ns / 1ps
module mux16_4 (A, B, C, D, SEL, OUT);

	input [15:0] A;
	input [15:0] B;
	input [15:0] C;
	input [15:0] D;
	input [1:0] SEL;
	output reg [15:0] OUT;
	
always  @ (A or B or C or D or SEL) begin
	case (SEL)
		2'b00: OUT <= A;
		2'b01: OUT <= B;
		2'b10: OUT <= C;
		2'b11: OUT <= D;
	endcase
end
endmodule

