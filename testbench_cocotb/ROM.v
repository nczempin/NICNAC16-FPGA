`timescale 1ns / 1ps


module ROM(
    input [7:0] address,
    output reg [15:0] data
    );
    always @(address)
    case (address)
    // ROM starts at $0100 at the moment; within it the addresses cut off the 01 (MSB)
      8'h00: data = 16'h4113; // LDA ($0113) a= 0xfffe
      8'h01: data = 16'h6114; // ADD ($0114) ++a
      8'h02: data = 16'h7104; // BAZ ($0104) if(a == 0)goto 0x104
      8'h03: data = 16'h1101; // JMP $0101
      8'h04: data = 16'hfc27; // DIO (in) $427
      8'h05: data = 16'hf75c; // DIO (out) $75c
      8'h06: data = 16'h4112; // LDA ($0112)
      8'h07: data = 16'h6111; // ADD ($0111)
      8'h08: data = 16'h5008; // STA $008 ;store result at address 8, which is in RAM
      8'h09: data = 16'hf75c; // DIO (out) $75c
      8'h0a: data = 16'hfc27; // DIO (in) $427
      8'h0b: data = 16'h1100; // JMP $0100
      8'h10: data = 16'h0007; // .dw 7
      8'h11: data = 16'h000c; // .dw $000c
      8'h12: data = 16'ha5c3; // .dw $a5c3
      8'h13: data = 16'b1111_1111_1111_1101; // .dw $fffd -- adding just three ones will wrap around to non-negative
      8'h14: data = 16'b0000_0000_0000_0001; // .dw $0001 
    
     default: data = 16'h05c5; //NOP with tag
    endcase
endmodule
