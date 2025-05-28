`timescale 1ns / 1ps

module console(
    input t3,
    input clk,
    input reset,
    input pushbutton,
    input [1:0] knob_setting,
    output RUN_MODE,
    output RUN_CY,
    output LOAD_SW,
    output WRITE_SW,
    output READ_SW,
    output RUN_SW,
    output CONCY1,
    output CONCY2
    );
    
    
     wire HALT;

    control_knob ck(
    .reset(reset),
    .HALT(HALT),
    .knob_setting(knob_setting),
    .RUN_CY(RUN_CY),
    .RUN_MODE(RUN_MODE),
    .CONCY1(CONCY1),
    .LOAD_SW(LOAD_SW),
    .WRITE_SW(WRITE_SW),
    .READ_SW(READ_SW),
    .RUN_SW(RUN_SW)
    );
console_timing ct(
.pushbutton(pushbutton),
    .t3(t3),
    .clk(clk),
    .reset(reset),
    .RUN_MODE(RUN_MODE),
    .CONCY1(CONCY1),
    .CONCY2(CONCY2)
);
endmodule
