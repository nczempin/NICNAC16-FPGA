// Simplified datapath module for ASIC synthesis
// Provides basic interface matching nicnac16_cpu.v expectations

module datapath (
    input wire clk,
    input wire rst,
    input wire [7:0] control_signals,
    input wire [15:0] mem_data_in,
    output wire [15:0] mem_data_out,
    output wire [11:0] mem_addr,
    output wire [15:0] accumulator,
    output wire [11:0] program_counter,
    output wire [15:0] instruction_register,
    output wire [15:0] data_to_control
);

    // Internal registers
    reg [15:0] acc_reg;
    reg [11:0] pc_reg;
    reg [15:0] ir_reg;
    reg [15:0] mem_data_reg;
    reg [11:0] mem_addr_reg;

    // Control signal decoding (simplified)
    wire load_acc = control_signals[0];
    wire load_pc = control_signals[1];
    wire load_ir = control_signals[2];
    wire inc_pc = control_signals[3];
    wire mem_read = control_signals[4];
    wire mem_write = control_signals[5];

    // Register updates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_reg <= 16'h0000;
            pc_reg <= 12'h000;
            ir_reg <= 16'h0000;
            mem_data_reg <= 16'h0000;
            mem_addr_reg <= 12'h000;
        end else begin
            if (load_acc)
                acc_reg <= mem_data_in;
            
            if (load_pc)
                pc_reg <= mem_data_in[11:0];
            else if (inc_pc)
                pc_reg <= pc_reg + 1;
            
            if (load_ir)
                ir_reg <= mem_data_in;
            
            if (mem_read)
                mem_addr_reg <= pc_reg;
            
            if (mem_write)
                mem_data_reg <= acc_reg;
        end
    end

    // Output assignments
    assign accumulator = acc_reg;
    assign program_counter = pc_reg;
    assign instruction_register = ir_reg;
    assign mem_addr = mem_addr_reg;
    assign mem_data_out = mem_data_reg;
    assign data_to_control = ir_reg; // Send instruction to control unit

endmodule