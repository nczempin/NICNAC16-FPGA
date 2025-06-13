`timescale 1ns / 1ps


module ring_counter_tb;
	// Inputs
	reg clock;
	reg reset;
	// Outputs
  wire[3:0] q;
  wire t0, t1, t2, t3;
	// Instantiate the Unit Under Test (UUT)
	four_bit_ring_counter r1 (
      .clock(clock), 
      .reset(reset), 
      .q(q)
	);
	reg icynext;
	
	wire new_cycle;
	//assign new_cycle = icynext |(~t0 & ~t1 & ~t2);
    
	
	timing_ring_counter trc (
	.clk(clock),
    .icynext(icynext),
    .t0(t0),
    .t1(t1),
    .t2(t2),
    .t3(t3),
    .new_cycle(new_cycle)
    );
 
  always #10 clock = ~clock;
 
	initial begin
		// Initialize Inputs
    clock = 0;  
	reset = 0;
    icynext = 0;
	#5 reset = 1;
	icynext = 1;
	#20 reset = 0;
        #5 icynext = 0;
        #1000 $finish;

    end
 
		initial begin
          $monitor($time, " clock=%1b,reset=%1b,q=%4b",clock,reset,q);
		 end
 
endmodule
