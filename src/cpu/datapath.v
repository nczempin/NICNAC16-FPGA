`timescale 1ns / 1ps


module datapath(clk, reset, fetch, execute, incr_pc, PC_IN,
         t0, t1, t2, t3,
         pc_out, ma_out, md_out, ac_out, alu_out,
         mem_read,
         I_JMP, I_NOP, I_BL, I_RET, I_LDA, I_STA, I_ADD, I_BAN, I_BAZ, I_DIO,
         EN_IR, EN_PC, EN_MA, EN_MD, EN_AC,
         DO_JUMP,
         MA_MUX_SEL, MD_MUX_SEL, AC_MUX_SEL, ALU_MUX_A_SEL, ALU_MUX_B_SEL,
         AN, AZ,
         DATA_BUS_IN,
         DATA_BUS_OUT,
         SW,
         do_load, do_write, do_read
         );
         
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
    input EN_AC;
    
    input DO_JUMP;
    
    //output [15:0] pc_out;
   
    output [15:0] ma_out;
    output  [15:0] md_out;
    output [15:0] ac_out;
    output [15:0] alu_out;
    
    input [15:0] mem_read;
    
    input I_JMP;
    input I_NOP;
    input I_LDA;
    input I_STA;
    input I_ADD;
    input I_BL;
    input I_RET;
    input I_BAN;
    input I_BAZ;
    input I_DIO;
    
    output  [15:0]pc_out;
 
    input[1:0]MA_MUX_SEL;
    input [1:0] MD_MUX_SEL;
    input [1:0] AC_MUX_SEL;
    input ALU_MUX_A_SEL;
    input ALU_MUX_B_SEL;

    output AN, AZ;
    
    input[15:0] DATA_BUS_IN;
    input[15:0] DATA_BUS_OUT;
    
    
    input [15:0] SW;
    input do_load, do_write, do_read;
 
    wire [15:0] MA_IN;
    wire [15:0] MD_IN;
    wire [15:0] AC_IN;
    
    wire [15:0] MA_MUX_OUT;
    wire [15:0] MD_MUX_OUT;
    wire [15:0] AC_MUX_OUT;
    
   // wire [15:0] mma; //M[MA]
    
    assign MA_IN = MA_MUX_OUT[11:0];
    assign MD_IN = MD_MUX_OUT;
    
    assign AC_IN = AC_MUX_OUT;
     
    
    wire CO;
    wire [15:0]JUMP_ADR;
    assign JUMP_ADR = md_out[11:0];
    
    wire [15:0] D;
    wire DO_RET;
    wire [15:0] reset_vector;
    assign reset_vector = 16'h0100; 
    
     //select1of4_16 pc_in_priority(reset_vector, JUMP_ADR, alu_out, D, reset, DO_JUMP, incr_pc, DO_RET, PC_IN);
     wire [1:0] PC_MUX_SEL;
     assign PC_MUX_SEL = reset ? 2'b00 :
                       DO_JUMP ? 2'b01 :
                       incr_pc ? 2'b10 :
                       do_load ? 2'b11 : 2'bz;
    mux16_4 pcmux(reset_vector,JUMP_ADR,alu_out,SW,
                  PC_MUX_SEL, PC_IN
                 );
    FD16CE PC(
       .D(PC_IN),
       .CE(EN_PC),
       .C(clk),
       .CLR(1'b0),
       .Q(pc_out)
    );
    wire[15:0] TODO; // TODO 11:0
    
    
    mux16_4 mamux( pc_out, md_out, SW, TODO, MA_MUX_SEL, MA_MUX_OUT);
    
    FD16CE MA(
       .D(MA_IN),
       .CE(EN_MA),
       .C(clk),
       .CLR(1'b0),
       .Q(ma_out)
    );
    mux16_4 mdmux( mem_read, ac_out, SW, TODO,
     MD_MUX_SEL, MD_MUX_OUT);
    
    FD16CE MD(
       .D(MD_IN),
       .CE(EN_MD),
       .C(clk),
       .CLR(reset),
       .Q(md_out)
    );
    
     mux16_4 acmux( md_out, alu_out, DATA_BUS_IN, SW,
                   AC_MUX_SEL, AC_MUX_OUT);
     
    FD16CE AC(
       .D(AC_IN),
       .CE(EN_AC),
       .C(clk),
       .CLR(reset),
       .Q(ac_out)
    );
    wire [15:0] ALU_IN_A;
    wire [15:0] ALU_IN_B;
    
    
    mux16_2 alumux_a( ac_out, pc_out, ALU_MUX_A_SEL, ALU_IN_A);
    mux16_2 alumux_b ( md_out, 16'b1, ALU_MUX_B_SEL, ALU_IN_B);
    
  ADSU16 ALU(ALU_IN_A, ALU_IN_B, CO, alu_out);
  
  
  
  ISNEG16 test_an(
   .I(ac_out),
   .O(AN)
  );
  bus_nor16 trest_az(
  .I(ac_out),
  .O(AZ)
  );
endmodule
