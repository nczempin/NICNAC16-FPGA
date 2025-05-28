`timescale 1ns / 1ps

module system_timing(clk, reset, icynext, t0, t1, t2, t3, fetch, execute, new_cycle, RUN_MODE, RUN_CY);
    input clk;
    input reset;
    input icynext;
    output t0;
    output t1;
    output t2;
    output t3;
    output fetch;
    output execute;
    
    output new_cycle;
    input RUN_MODE;
    input RUN_CY;
    
    timing_ring_counter trc(
    .clk(clk),
    .icynext(icynext),
    .t0(t0),
    .t1(t1),
    .t2(t2),
    .t3(t3),
    .new_cycle(new_cycle)
    );
    Stages stages (
    .RESET(reset),
    .CLK(clk),
    .NEW_CYCLE(new_cycle),
    .FETCH(fetch),
    .EXECUTE(execute),
    .RUN_MODE(RUN_MODE),
    .RUN_CY(RUN_CY)
    );
endmodule
