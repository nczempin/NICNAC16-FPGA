`timescale 100 ps / 10 ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2019 10:25:05 PM
// Design Name: 
// Module Name: FD16CE
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


module FD16CE(D,CE,C,CLR,Q);
    
    input [15:0] D;
    input CE;
    input C;
    input CLR;
    output reg [15:0] Q;
    
 
    always @ ( posedge C or posedge CLR)
    begin
        if (CLR)
		Q <= 16'h0000; 
	else if (CE)
		Q <= D;
	end
endmodule
