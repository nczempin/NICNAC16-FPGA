`timescale 1ns / 1ps
`timescale 1ns / 1ps
module d_ff_sc (
     input clk,
     input clr,
     input d,
     output reg o
);

   always @(negedge clr or posedge clk)
      if (!clr) begin
         o <= 1'b0;
      end else begin
         o <= d;
      end
endmodule