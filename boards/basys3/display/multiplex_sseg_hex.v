`timescale 1ns / 1ps
`timescale 1ns / 1ps
module multiplex_sseg_hex(
 input clk,
 input [3:0] in0,
 input [3:0] in1,
 input [3:0] in2,
 input [3:0] in3,
 input [3:0] dp,
 output [7:0] sseg_ca,
 output reg [3:0] sseg_an
 );
 reg [3:0] chosen_input;
wire [6:0] sseg_ca_decoded;
reg my_dp; 

assign sseg_ca = {my_dp, sseg_ca_decoded};
sseg_hex_decoder shd(chosen_input, sseg_ca_decoded);
reg [1:0] count = 2'b00; 

 
always @ (posedge clk)
 begin
   count <= count + 1;
  case(count) 
    
   2'b00:
    begin
     chosen_input <= in0;
      sseg_an <= 4'b1110;
      my_dp <= dp[0];
    end
    
   2'b01:
    begin
     chosen_input <= in1;
     sseg_an  <= 4'b1101;
      my_dp <= dp[1];
  end
    
   2'b10:
    begin
     chosen_input <= in2;
     sseg_an <= 4'b1011;
     my_dp <= dp[2];
   end
     
   2'b11:
    begin
     chosen_input <= in3;
      sseg_an <= 4'b0111;
     my_dp <= dp[3];
    end
  endcase
 end

endmodule
