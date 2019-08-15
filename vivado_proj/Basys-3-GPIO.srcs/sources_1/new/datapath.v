`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2019 09:12:04 AM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(clk, reset, fetch, execute, incr_pc, PC_IN,
         t0, t1, t2, t3,
         pc_out, ir_out, ma_out, md_out, ac_out,
         MEMORY_READ,
         I_NOP, I_JMP,
         EN_IR, EN_PC, EN_MA, EN_MD,
         DO_JUMP);
         
    input clk;
    input reset;
    input fetch;
    input execute;
    input incr_pc;
    
    output[15:0] PC_IN;
    
    input t0, t1, t2, t3;
    
    input EN_IR;
    input EN_PC;
    input EN_MA;
    input EN_MD;
    
    input DO_JUMP;
    
    output [15:0] pc_out;
    output [3:0] ir_out;
    output [15:0] ma_out;
    input  [15:0] md_out;
    output reg [15:0] ac_out;
    
    input [15:0] MEMORY_READ;
    
    output I_NOP;
    output I_JMP;
   
    wire [15:0] ALU_OUT;
    wire [15:0] MA_IN;
    wire [15:0] MD_IN;
    
    wire [15:0] MA_MUX_OUT;
    
    assign MA_IN= MA_MUX_OUT[11:0];
    assign MD_IN = MEMORY_READ; // TODO mux
    
    REG4CE IR(ir_out, clk, EN_IR, reset, md_out[15:12]);
    
    wire D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15;
    assign I_NOP = D0;
    assign I_JMP = D1;
    wire CO;
    wire [15:0]JUMP_ADR;
    assign JUMP_ADR = md_out[11:0];
    Decoder4_16 instruction_decoder(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, ir_out, ~reset);
    
    select1of4_16 pc_in_priority(JUMP_ADR, ALU_OUT, 0, D, DO_JUMP, incr_pc, 0, DO_RET, PC_IN);

    FD16CE PC(
       .D(PC_IN),
       .CE(EN_PC),
       .C(clk),
       .CLR(reset),
       .Q(pc_out)
    );
    
    wire MA_MUX_SEL;
    assign MA_MUX_SEL = fetch & t3; //TODO document as to why
    mux16_2 mamux( pc_out, md_out, MA_MUX_SEL, MA_MUX_OUT);
    
    FD16CE MA(
       .D(MA_IN),
       .CE(EN_MA),
       .C(clk),
       .CLR(reset),
       .Q(ma_out)
    );
      // mux16_2 mdmux( pc_out, md_out, MA_MUX_SEL, MA_MUX_OUT);
    
    FD16CE MD(
       .D(MD_IN),
       .CE(EN_MD),
       .C(clk),
       .CLR(reset),
       .Q(md_out)
    );
    
    ADSU16 ALU(pc_out, 1, CO, ALU_OUT);
    
    always @(posedge clk or posedge reset)
    
    if (reset) begin
       ac_out<=0;
 
    end 
endmodule
