// NICNAC16 Generic Platform Wrapper
// For simulation and open-source tool testing

module nicnac16_generic (
    // Clock and Reset
    input wire clk,
    input wire rst_n,
    
    // External Memory Interface (for simulation)
    output wire [11:0] ext_mem_addr,
    input wire [15:0] ext_mem_data_in,
    output wire [15:0] ext_mem_data_out,
    output wire ext_mem_write,
    output wire ext_mem_read,
    
    // Simple Control Interface
    input wire run,
    input wire step,
    input wire [3:0] control_switches,
    
    // Status Outputs
    output wire [15:0] accumulator_out,
    output wire [11:0] pc_out,
    output wire [15:0] ir_out,
    output wire halted,
    output wire [2:0] cpu_state_out,
    
    // Simple I/O for testing
    output wire [7:0] debug_leds,
    input wire [7:0] debug_switches
);

    // Internal reset (active high for CPU core)
    wire rst = ~rst_n;
    
    // Instantiate the hardware-independent CPU core
    nicnac16_cpu cpu_core (
        .clk(clk),
        .rst(rst),
        .mem_addr(ext_mem_addr),
        .mem_data_in(ext_mem_data_in),
        .mem_data_out(ext_mem_data_out),
        .mem_write_enable(ext_mem_write),
        .mem_read_enable(ext_mem_read),
        .run(run),
        .step(step),
        .control_input(control_switches),
        .accumulator(accumulator_out),
        .program_counter(pc_out),
        .instruction_register(ir_out),
        .halted(halted),
        .cpu_state(cpu_state_out)
    );
    
    // Simple debug interface
    assign debug_leds = {
        halted,
        cpu_state_out,
        accumulator_out[15:12]
    };

endmodule
