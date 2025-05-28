`timescale 1ns / 1ps


module two_bit_ring_counter (
      input clock,
      input reset,
      input enable,
      output [1:0] q,
      input d
    );
 
  reg[1:0] a;
 
    always @(posedge clock)
      if (reset)
        a <= 4'b01;
 
      else
      if (enable)
      //TODO this can be simplified by using d as a bit in the assignments
      if (1'b1) //TODO d
      //if (d)
          case (a)
           2'b00: a <= 2'b01; // happens only on reset
           2'b01: a <= 2'b10;
           2'b10: a <= 2'b01;
           2'b11: a <= 2'b01; // technically, shouldn't happen
        endcase
      else
          case (a)
           2'b00: a <= 2'b00; // happens only on reset
           2'b01: a <= 2'b10;
           2'b10: a <= 2'b00;
           2'b11: a <= 2'b00; // technically, shouldn't happen
        endcase
    
        // else a=a
 
    assign q = a;
 
  endmodule
 
module Stages(CLK, RESET, NEW_CYCLE, FETCH, EXECUTE, RUN_MODE, RUN_CY);
    input CLK;
    input RESET;
    input NEW_CYCLE;
    output FETCH;
    output EXECUTE;
    input RUN_MODE;
    input RUN_CY;
    
    wire fetch_in;
    assign fetch_in = RUN_CY | (RUN_MODE & ~FETCH);
    
    two_bit_ring_counter tbrc (
    .q({EXECUTE, FETCH}),
    .clock(CLK),
    .reset(RESET),
    .enable(NEW_CYCLE),
    .d(fetch_in)
    );
    
endmodule
