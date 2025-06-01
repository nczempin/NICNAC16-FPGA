`timescale 1ns / 1ps


module dunc16(
    clk,
    reset,
    led_out,
    status,
    mem_address,
    mem_read,
    mem_write,
    en_mem_write,
    DATA_BUS_IN,
    DATA_BUS_OUT,
    DEVADDRESS,
    DEVCTRL,
    OUTP,
    INP,
    t3, //TODO
    RUN_MODE,
    RUN_CY,
    pushbutton,
    LOAD_SW, WRITE_SW, READ_SW, RUN_SW,
    SW,
    CONCY1,
    CONCY2
);
   output [4:0] DEVADDRESS;
   output [5:0] DEVCTRL;
   output OUTP;
   output INP;
   input pushbutton;



    input clk, reset;
    //
    
    output [15:0] led_out;
    output status;
    output [15:0] mem_address;
    output [15:0] mem_read;
    output [15:0] mem_write;
    output en_mem_write;
    input [15:0] DATA_BUS_IN;
    output [15:0] DATA_BUS_OUT;
    
    wire t0, t1, t2;
    output t3;
    input RUN_MODE;
    input RUN_CY;
    input LOAD_SW, WRITE_SW, READ_SW, RUN_SW;
    input [15:0] SW;
    input CONCY1;
    input CONCY2;

    wire fetch;
    wire execute;
    
    wire [15:0] pc_out;
    wire [15:0] ac_out;
    wire [15:0] ma_out; 
    assign mem_address = ma_out;
    
    //assign en_mem_write = 1'b0;    
    
    wire [15:0] md_out;
    assign mem_write = md_out;
    wire [4:0] ir_out;
    wire [15:0] alu_out;
    wire incr_pc;
    
    wire [15:0] PC_IN;
    
    wire I_NOP, I_JMP, I_BL, I_RET, I_LDA, I_STA, I_ADD, I_BAN, I_BAZ, I_DIO;
    wire EN_IR, EN_PC, EN_MA, EN_MD, EN_AC;
    
    wire do_jump;
    wire[1:0] MA_MUX_SEL;
    wire [1:0] MD_MUX_SEL;
    wire [1:0]  AC_MUX_SEL;
    wire ALU_MUX_A_SEL;
    wire ALU_MUX_B_SEL;
    
    wire AZ, AN;
    
    assign led_out ={reset,fetch, execute,clk, pc_out[11:0]};


    assign status =fetch;
    wire do_load, do_read, do_write;
    datapath dp (
       .clk(clk),
       .reset(reset),
       .fetch(fetch),
       .execute(execute),
       .incr_pc(incr_pc),
       .PC_IN(PC_IN),
       .t0(t0),
       .t1(t1),
       .t2(t2),
       .t3(t3),
       .pc_out(pc_out),
       .ma_out(ma_out),
       .md_out(md_out),
       .ac_out(ac_out),
       .alu_out(alu_out),
       .mem_read(mem_read),
       .I_NOP(I_NOP),
       .I_JMP(I_JMP),
       .I_BL(I_BL),
       .I_RET(I_RET),
       .I_LDA(I_LDA),
       .I_STA(I_STA),
       .I_BAZ(I_BAZ),
       .I_BAN(I_BAN),
       .I_ADD(I_ADD),
       .I_DIO(I_DIO),
       .EN_IR(EN_IR),
       .EN_PC(EN_PC),
       .EN_MA(EN_MA),
       .EN_MD(EN_MD),
       .EN_AC(EN_AC),
       .DO_JUMP(do_jump),
       .MA_MUX_SEL(MA_MUX_SEL),
       .MD_MUX_SEL(MD_MUX_SEL),
       .AC_MUX_SEL(AC_MUX_SEL),
       .ALU_MUX_A_SEL(ALU_MUX_A_SEL),
       .ALU_MUX_B_SEL(ALU_MUX_B_SEL),
       .AN(AN),
       .AZ(AZ),
         .DATA_BUS_IN(DATA_BUS_IN),
        .DATA_BUS_OUT(DATA_BUS_OUT),
       .SW(SW),
       .do_load(do_load),
       .do_write(do_write),
       .do_read(do_read)
    );
     
    
    control_unit cu( 
        .clk(clk),
        .reset(reset),
        .fetch(fetch),
        .execute(execute),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3),
        .I_NOP(I_NOP),
        .I_JMP(I_JMP),
        .I_BL(I_BL),
        .I_RET(I_RET),
        .I_LDA(I_LDA),
        .I_STA(I_STA),
        .I_BAZ(I_BAZ),
        .I_BAN(I_BAN),
        .I_ADD(I_ADD),
        .I_DIO(I_DIO),
        .incr_pc(incr_pc),
        .do_jump(do_jump),
        .EN_IR(EN_IR),
        .EN_PC(EN_PC),
        .EN_MA(EN_MA),
        .EN_MD(EN_MD),
        .EN_AC(EN_AC),
        .ir_out(ir_out),
        .ir_in(md_out[15:11]),
        .MA_MUX_SEL(MA_MUX_SEL),
        .MD_MUX_SEL(MD_MUX_SEL),
        .AC_MUX_SEL(AC_MUX_SEL),
        .ALU_MUX_A_SEL(ALU_MUX_A_SEL),
        .ALU_MUX_B_SEL(ALU_MUX_B_SEL),
        .en_mem_write(en_mem_write),
        .AN(AN),
        .AZ(AZ),
        .ac_out(ac_out),
        .DATA_BUS_IN(DATA_BUS_IN),
        .DATA_BUS_OUT(DATA_BUS_OUT),
        .DEVADDRESS(DEVADDRESS),
        .DEVCTRL(DEVCTRL) ,
        .md_out(md_out),
        .OUTP(OUTP),
        .RUN_MODE(RUN_MODE),
        .RUN_CY(RUN_CY),
        .pushbutton(pushbutton),
        .LOAD_SW(LOAD_SW),
        .WRITE_SW(WRITE_SW),
        .READ_SW(READ_SW),
        .RUN_SW(RUN_SW),
        .CONCY1(CONCY1),
        .CONCY2(CONCY2),
        .do_load(do_load),
        .do_write(do_write),
        .do_read(do_read)
     );
  
endmodule
