// NICNAC16 CPU Core - Hardware Independent
// This module provides a clean interface for the NICNAC16 processor core
// that can be instantiated by different platform-specific top-level modules

module nicnac16_cpu (
    // Clock and Reset
    input wire clk,
    input wire rst,
    
    // Memory Interface
    output wire [11:0] mem_addr,
    input wire [15:0] mem_data_in,
    output wire [15:0] mem_data_out,
    output wire mem_write_enable,
    output wire mem_read_enable,
    
    // Control Interface
    input wire run,
    input wire step,
    input wire [3:0] control_input,
    
    // Status Outputs
    output wire [15:0] accumulator,
    output wire [11:0] program_counter,
    output wire [15:0] instruction_register,
    output wire halted,
    output wire [2:0] cpu_state
);

    // Internal connections between datapath and control unit
    wire [15:0] datapath_to_control;
    wire [15:0] control_to_datapath;
    wire [7:0] control_signals;
    wire [2:0] timing_state;
    
    // Instantiate the datapath
    datapath cpu_datapath (
        .clk(clk),
        .rst(rst),
        .control_signals(control_signals),
        .mem_data_in(mem_data_in),
        .mem_data_out(mem_data_out),
        .mem_addr(mem_addr),
        .accumulator(accumulator),
        .program_counter(program_counter),
        .instruction_register(instruction_register),
        .data_to_control(datapath_to_control)
    );
    
    // Instantiate the control unit
    control_unit cpu_control (
        .clk(clk),
        .rst(rst),
        .run(run),
        .step(step),
        .control_input(control_input),
        .data_from_datapath(datapath_to_control),
        .control_signals(control_signals),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable),
        .halted(halted),
        .cpu_state(cpu_state)
    );
    
    // Instantiate system timing
    system_timing cpu_timing (
        .clk(clk),
        .rst(rst),
        .run(run),
        .timing_state(timing_state)
    );

endmodule