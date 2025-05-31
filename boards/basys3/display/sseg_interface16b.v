`timescale 1ns / 1ps
   module sseg_interface16b (
        input clk,
        input [15:0] data,
        input [3:0] decimal_points, //TODO
        output [7:0] sseg_ca,
        output [3:0] sseg_an
        );
        
        
        wire [3:0] d0;
        wire [3:0] d1;
        wire [3:0] d2;
        wire [3:0] d3;
        
        assign d0 = data[15:12];
        assign d1 = data[11:8];
        assign d2 = data[7:4];
        assign d3 = data[3:0];
        
//        assign d0 = 4'h1;
//        assign d1 = 4'h2;
//        assign d2 = 4'h3;
//        assign d3 = 4'h4;
        
        reg clk_multiplex;
        
     
  multiplex_sseg_hex sseg_multiplexer(
     .clk(clk_multiplex),
     //TODO exactly where to be little or big endian, so to speak
     .in0(d3),
     .in1(d2),
     .in2(d1),
     .in3(d0),
     .dp(decimal_points),
     .sseg_ca(sseg_ca),
     .sseg_an(sseg_an)
 );
 
 localparam N = 18;
 
reg [N-1:0] count = 0; 
 
always @ (posedge clk)
 begin
   count <= count + 1;
   if (count==0)
      clk_multiplex <= ~clk_multiplex;
 end


    endmodule
