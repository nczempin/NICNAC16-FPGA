// Verilog test fixture created from schematic B:\NICNAC16\dunc16.sch - Wed Sep 17 00:13:28 2014

`timescale 10ns / 1ps

module dunc16_tb();

// Inputs
    reg clk;
   reg reset;

//wire [15:0] pc_out;
//wire [15:0] ac_out;
//wire [15:0] ma_out;
//wire [15:0] MEMORY_READ;
wire [15:0] led_out;
wire status;

// Bidirs

// Instantiate the UUT
   dunc16 UUT (
		.clk(clk), 
		.reset(reset),
		//.pc_out(pc_out),
		//.ac_out(ac_out),
		//.ma_out(ma_out),
		//.MEMORY_READ(MEMORY_READ),
		.status(status),
		.led_out(led_out)
   );
//initial begin  
//	//$monitor("%b%b%b%b PC=%h, f%be%b, s%bl%b. %h %h",UUT.T0,UUT.T1,UUT.T2,UUT.T3,UUT.PC.Q,UUT.FETCH, UUT.EXECUTE, I_STA, UUT.I_LDA, UUT.MD.Q, UUT.AC.Q);  
//    $monitor("%b%b PC=%h,",CLK, RESET,PC_OUT);  
//end
initial begin
clk=1;
//enable = 0;
//md_out = 0;


	//start reset

	reset = 1'b1;
	
		#4
	reset = 1'b0;
	// end reset
	

end
always #1 clk =~clk;

//initial begin
////	ININ = 0;
//	CLK = 0;
//	//start reset
//	RESET = 1'b1;
//	repeat(4)
//		#1
//		CLK = ~CLK;
//	RESET = 1'b0;
//	// end reset
	
//	forever
//		#1
//		CLK = ~CLK; // generate a clock
//end

//initial begin
//	@(negedge RESET); // wait for reset
//	repeat (96)
//	@(posedge CLK);


//	//$finish;
//end
endmodule
