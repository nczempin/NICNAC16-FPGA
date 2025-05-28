`timescale 1ns / 1ps


module Memory_tb;

	// Inputs
	reg [15:0] ADDRESS;
	reg [15:0] IN;
	reg WRITE;
	reg CLK;

	// Outputs
	wire [15:0] OUT;

	// Instantiate the Unit Under Test (UUT)
	Memory uut (
		.mem_address(ADDRESS), 
		.mem_write(IN), 
		.en_mem_write(WRITE), 
		.clk(CLK), 
		.mem_read(OUT)
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
	ADDRESS = 16'h01cd; //rom
	WRITE = 1;
@(posedge CLK);
	IN = 16'hbeef;
	ADDRESS = 16'h01ce; //rom write should do nothing
	WRITE = 1;
@(posedge CLK);
	WRITE = 0;
@(posedge CLK);
	ADDRESS = 16'h01cd;
@(posedge CLK);
	IN = 16'hdead;
	ADDRESS = 16'h00cd; //rom
	WRITE = 1;
@(posedge CLK);
	IN = 16'hbeef;
	ADDRESS = 16'h00ce; //rom write should do nothing
	WRITE = 1;
@(posedge CLK);
	WRITE = 0;
@(posedge CLK);
	ADDRESS = 16'h00cd;	
	repeat (2)
		@(posedge CLK);
    ADDRESS = 16'h01cd;	
    @(posedge CLK);
    ADDRESS =16'h0100;

	repeat (8) begin
		@(posedge CLK);
		ADDRESS <= ADDRESS +1;
		end
	@(posedge CLK);
	ADDRESS=16'h0000;
	IN = 16'hc5c5;
	WRITE =1;
	repeat (8) begin
		@(posedge CLK);
		
		ADDRESS <= ADDRESS +1;
		end
	@(posedge CLK);
	ADDRESS=16'h0000;
	IN = 16'h1234;
	WRITE =0;
	repeat (8) begin
		@(posedge CLK);
		
		ADDRESS <= ADDRESS +1;
		end
	$finish;
	end
      
endmodule

