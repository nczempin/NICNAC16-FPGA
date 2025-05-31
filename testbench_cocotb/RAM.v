`timescale 1ns / 1ps
//synchronous ram
module RAM (
	input  [7:0]ADDRESS,
	input [15:0] IN,
	input WRITE,
	input CLK,


	output [15:0] OUT
);
	 
	reg    [15:0] ram[0:255]; 
	always @(posedge CLK) begin
		if (WRITE) begin
			ram[ADDRESS] <= IN;
		end 
	end
assign OUT = ram[ADDRESS];

endmodule
