// Simplified control unit module for ASIC synthesis
// Provides basic interface matching nicnac16_cpu.v expectations

module control_unit (
    input wire clk,
    input wire rst,
    input wire run,
    input wire step,
    input wire [3:0] control_input,
    input wire [15:0] data_from_datapath,
    output reg [7:0] control_signals,
    output reg mem_write_enable,
    output reg mem_read_enable,
    output reg halted,
    output reg [2:0] cpu_state
);

    // State machine states
    localparam FETCH = 3'b000;
    localparam DECODE = 3'b001;
    localparam EXECUTE = 3'b010;
    localparam HALT = 3'b111;

    // Internal registers
    reg [2:0] next_state;
    reg [3:0] opcode;
    reg [11:0] operand;

    // Extract instruction fields
    always @(*) begin
        opcode = data_from_datapath[15:12];
        operand = data_from_datapath[11:0];
    end

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cpu_state <= FETCH;
            halted <= 1'b0;
            control_signals <= 8'h00;
            mem_write_enable <= 1'b0;
            mem_read_enable <= 1'b0;
        end else if (run || step) begin
            cpu_state <= next_state;
            
            case (cpu_state)
                FETCH: begin
                    // Fetch instruction from memory
                    control_signals[4] <= 1'b1; // mem_read
                    control_signals[2] <= 1'b1; // load_ir
                    mem_read_enable <= 1'b1;
                    mem_write_enable <= 1'b0;
                    next_state <= DECODE;
                end
                
                DECODE: begin
                    // Decode instruction
                    control_signals <= 8'h00; // Clear control signals
                    mem_read_enable <= 1'b0;
                    next_state <= EXECUTE;
                end
                
                EXECUTE: begin
                    // Execute based on opcode
                    case (opcode)
                        4'h0: begin // NOP
                            control_signals[3] <= 1'b1; // inc_pc
                            next_state <= FETCH;
                        end
                        4'h1: begin // JMP
                            control_signals[1] <= 1'b1; // load_pc
                            next_state <= FETCH;
                        end
                        4'h4: begin // LDA
                            control_signals[0] <= 1'b1; // load_acc
                            control_signals[3] <= 1'b1; // inc_pc
                            next_state <= FETCH;
                        end
                        4'h5: begin // STA
                            control_signals[5] <= 1'b1; // mem_write
                            control_signals[3] <= 1'b1; // inc_pc
                            mem_write_enable <= 1'b1;
                            next_state <= FETCH;
                        end
                        4'h6: begin // ADD
                            control_signals[0] <= 1'b1; // load_acc (simplified)
                            control_signals[3] <= 1'b1; // inc_pc
                            next_state <= FETCH;
                        end
                        default: begin
                            halted <= 1'b1;
                            next_state <= HALT;
                        end
                    endcase
                end
                
                HALT: begin
                    halted <= 1'b1;
                    control_signals <= 8'h00;
                    mem_write_enable <= 1'b0;
                    mem_read_enable <= 1'b0;
                    next_state <= HALT;
                end
                
                default: begin
                    next_state <= FETCH;
                end
            endcase
        end
    end

endmodule