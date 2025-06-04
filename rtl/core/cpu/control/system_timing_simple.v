// Simplified system timing module for ASIC synthesis
// Provides basic interface matching nicnac16_cpu.v expectations

module system_timing (
    input wire clk,
    input wire rst,
    input wire run,
    output reg [2:0] timing_state
);

    // Simple timing counter
    reg [1:0] timing_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timing_counter <= 2'b00;
            timing_state <= 3'b000;
        end else if (run) begin
            timing_counter <= timing_counter + 1;
            timing_state <= {1'b0, timing_counter};
        end
    end

endmodule