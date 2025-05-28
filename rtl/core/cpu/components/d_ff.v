`timescale 1ns / 1ps
module d_ff (
     input clk,
     input clr,
     input d,
     output reg o
);
    always @(posedge clk or negedge clr)
      if (~clr) begin
         o <= 1'b0;
      end else begin
         o <= d;
      end
endmodule