`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:06:57 09/19/2014 
// Design Name: 
// Module Name:    address_splitter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module address_splitter(
    input [15:0] IN,
    output [7:0] LOW,
    output [7:0] HIGH
    );

assign LOW = IN[7:0];
assign HIGH = IN[15:8];
endmodule
