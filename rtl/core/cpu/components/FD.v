`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2019 03:29:16 PM
// Design Name: 
// Module Name: FD
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


module FD(D,C,Q);
    input D;
    input C;
    output reg Q;
    
    always @ (posedge C )
    begin
        Q <= D;
    end
endmodule
