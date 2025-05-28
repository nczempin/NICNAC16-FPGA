`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2019 11:34:01 AM
// Design Name: 
// Module Name: ADSU16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 
module ADSU16(A,B, CO, S);
input A;
 input B;
 output CO;
 output S;
  parameter ADDER_WIDTH = 16;
  wire signed [ADDER_WIDTH-1:0] A;
   wire signed [ADDER_WIDTH-1:0] B;
   wire                   CO;
   wire signed [ADDER_WIDTH-1:0] S;

   assign {CO, S} = A + B;
	
endmodule
