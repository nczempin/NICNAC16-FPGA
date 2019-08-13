`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2019 04:33:44 PM
// Design Name: 
// Module Name: FDSE
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


module FDSE(
    input D,
    input CE,
    input C,
    input S,
    output reg Q
    );
    
    always @ ( posedge C  )
	if (S)
		Q <= 1;
	else if (CE)
		Q <= D;
endmodule
