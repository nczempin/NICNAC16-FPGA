`timescale 1ns / 1ps

module ISNEG16(I, O);
    

   output O;

   input [15:0]I;

	assign O = I[15];

endmodule
