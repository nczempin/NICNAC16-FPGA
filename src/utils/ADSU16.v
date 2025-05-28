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
  parameter ADDER_WIDTH = 16;
  input signed [ADDER_WIDTH-1:0] A;
  input signed [ADDER_WIDTH-1:0] B;
  output                   CO;
  output signed [ADDER_WIDTH-1:0] S;

   assign {CO, S} = A + B;
	
endmodule
