`timescale 1ns / 1ps
module bus_nor16( I, O);
    

   output O;

   input [15:0]I;

	assign O = ~|I;


endmodule
