`timescale 1ns / 1ps
module console_timing (
    input pushbutton,
    input t3,
    input clk,
    input reset,
    input RUN_MODE,
    output CONCY1,
    output CONCY2
);
wire ff1_out;
wire ff2_out;
wire ff3_out;
assign CONCY1 =ff3_out;
wire ff4_out;
assign CONCY2=ff4_out;
wire clearem;
assign clearem = ~(reset|CONCY2  |RUN_MODE);
wire t3_rise;
assign t3_rise = ~(t3&clk);

wire ff1_in;
assign ff1_in = pushbutton ;
   d_ff ff1(
      .d(1'b1),
      .o(ff1_out),
      .clr(clearem),
      .clk(ff1_in) // TODO debounce
   );
   d_ff ff2(
      .d(ff1_out),
      .o(ff2_out),
      .clr(clearem),
      .clk(t3_rise) 
   );
   d_ff ff3(
      .d(ff2_out),
      .o(ff3_out),
      .clr(clearem),
      .clk(t3_rise)
   );
   d_ff ff4(
      .d(ff3_out),
      .o(ff4_out),
      .clk(t3_rise)
   );
   

endmodule