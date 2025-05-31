`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:00:31 09/21/2014
// Design Name:   RAM
// Module Name:   B:/NICNAC16/RAM_tb.v
// Project Name:  NICNAC16
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RAM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RAM_tb;

	// Inputs
	reg [7:0] ADDRESS;
	reg [15:0] IN;
	reg WRITE;
	reg CLK;

	// Outputs
	wire [15:0] OUT;

	// Instantiate the Unit Under Test (UUT)
	RAM uut (
		.ADDRESS(ADDRESS), 
		.IN(IN), 
		.WRITE(WRITE), 
		.CLK(CLK), 
		.OUT(OUT)
	);
initial begin
	CLK = 0;
//	//start reset
//	RESET = 1'b1;
//	repeat(4)
//		#1
//		CLK = ~CLK;
//	RESET = 1'b0;
//	// end reset
	
	forever
		#10
		CLK = ~CLK; // generate a clock
end

initial begin
		// Initialize Inputs
		ADDRESS = 0;
		IN = 0;
		WRITE = 0;
		CLK = 0;
@(posedge CLK);
	IN = 16'hdead;
	ADDRESS = 16'habcd;
	WRITE = 1;
@(posedge CLK);
	IN = 16'hbeef;
	ADDRESS = 16'habce;
	WRITE = 1;
@(posedge CLK);
	WRITE = 0;
@(posedge CLK);
	ADDRESS = 16'habcd;
	
	repeat (32)
		@(posedge CLK);
	$finish;
	end
      
endmodule

