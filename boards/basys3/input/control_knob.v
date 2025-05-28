`timescale 1ns / 1ps


module control_knob(
    input reset,
    input HALT,
    input [1:0] knob_setting,
    output RUN_CY,
    output RUN_MODE,
    input CONCY1,
    output LOAD_SW, READ_SW, WRITE_SW, RUN_SW
    );
    assign RUN_SW = knob_setting == 2'b00;
    assign WRITE_SW = knob_setting == 2'b10;
    assign READ_SW = knob_setting == 2'b01;
    assign LOAD_SW = knob_setting == 2'b11;
    
    assign RUN_CY = CONCY1 & RUN_SW;
    wire do_halt;
    assign do_halt = reset | LOAD_SW | WRITE_SW| READ_SW;
    d_ff RUN (
       .clk(~RUN_CY),
       .clr(~do_halt),
       .d(1'b1),
       .o(RUN_MODE)
    );
    
    
endmodule
