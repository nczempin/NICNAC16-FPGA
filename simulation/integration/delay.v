`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2019 03:23:28 PM
// Design Name: 
// Module Name: delay
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


module delay(
    input ENABLE_NEXT,
    input I,
    input reset,
    input CLK,
    output O,
    output T,
    output _T
    );
//    FDCE #(
//      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
//   ) dff_d (
//      .Q(T),      // 1-bit Data output
//      .C(CLK),      // 1-bit Clock input
//      .CE(1),    // 1-bit Clock enable input
//      .CLR(reset),  // 1-bit Asynchronous clear input
//      .D(I)       // 1-bit Data input
//   );
    
    
        FD dff_d (
       .D(I),
       .C( CLK),
       .Q( T)
       );
    assign _T = ~T;
    assign  O = T & ENABLE_NEXT;
    
endmodule
