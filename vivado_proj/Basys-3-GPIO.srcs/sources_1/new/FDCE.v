`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2019 04:33:44 PM
// Design Name: 
// Module Name: FDCE
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


module FDCE(D,CE,C,CLR,Q);
    input D;
    input CE;
    input C;
    input CLR;
    output Q;
    reg Q;
    
    always @ ( posedge C or posedge CLR)
    begin
        if (CLR)
		Q = 0;
	else if (CE)
		Q <= D;
	end
endmodule