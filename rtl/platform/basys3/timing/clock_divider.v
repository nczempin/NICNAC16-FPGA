`timescale 1ns / 1ps



module clock_divider (clk_in, reset, clk_out);
   parameter MAX_COUNT = 2_000_000 -1;
    input clk_in;
    input reset;
    output clk_out;
    wire counter_en;
    reg [26:0] counter_big;
    reg [3:0] counter_10;

 assign counter_en = counter_big == 0;

   always @ (posedge clk_in, posedge reset) begin
   if(reset)
      counter_big <= 0;
    else if (counter_big == MAX_COUNT)
       counter_big <= 0;
    else
       counter_big <= counter_big + 1'b1;
  end
  
    always @(posedge clk_in, posedge reset) begin
     if (reset)
        counter_10 <=0;
     else if (counter_en)
        if (counter_10 == 9)
           counter_10 <= 0;
        else 
           counter_10 <= counter_10 + 1'b1;
     end
           
           
           
    assign clk_out =  counter_10 < 5;

    
endmodule
