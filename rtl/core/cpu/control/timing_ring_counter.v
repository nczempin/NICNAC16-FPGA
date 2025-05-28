`timescale 1ns / 1ps


module four_bit_ring_counter (
      input clock,
      input reset,
  output [3:0] q
    );
 
  reg[3:0] a;
 
    always @(posedge clock)
      if (reset)
        a = 4'b0001;
 
      else
        begin
        a <=  a<<1; // Notice the blocking assignment
        a[0]<=a[3];
        end
 
    assign q = a;
 
  endmodule
  
  
module timing_ring_counter(clk, icynext, t0, t1, t2, t3, new_cycle);
    input clk;
    input icynext;
    output t0;
    output t1;
    output t2;
    output t3;
    output new_cycle;
    
    
    wire [3:0] t;

    assign t0 = t[0];
    assign t1 = t[1];
    assign t2 = t[2];
    assign t3 = t[3];
    four_bit_ring_counter fbrc (
    .clock(clk),
    .reset(new_cycle),
    .q(t)
    );
    
    assign new_cycle = icynext |(~t0 & ~t1 & ~t2);

endmodule
