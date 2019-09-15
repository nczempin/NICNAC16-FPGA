`timescale 1ns / 1ps

module control_unit(clk, reset, fetch, execute, 
                    t0, t1, t2, t3,
                    I_JMP, I_NOP, I_BL, I_RET, I_LDA, I_STA, I_ADD, I_BAN, I_BAZ, 
                    incr_pc, do_jump,
                     EN_IR, EN_PC, EN_MA, EN_MD, EN_AC,
                     ir_out, ir_in,
                     MA_MUX_SEL, MD_MUX_SEL, AC_MUX_SEL, ALU_MUX_A_SEL, ALU_MUX_B_SEL,
                     en_mem_write
                      );
    input clk;
    input reset;
    input [3:0] ir_in;
    output [3:0] ir_out;
    output fetch;
    output execute;
    
    output t0, t1, t2, t3;
    output I_JMP;
    output I_NOP;
    output I_LDA;
    output I_STA;
    output I_ADD;
    output I_BL;
    output I_RET;
    output I_BAN;
    output I_BAZ;
    
    
    output incr_pc;
    output do_jump;
    
    output EN_IR;
    output EN_PC;
    output EN_MA;
    output EN_MD;
    output EN_AC;
    
    output MA_MUX_SEL;
    output MD_MUX_SEL;
    output AC_MUX_SEL;
    output ALU_MUX_A_SEL;
    output ALU_MUX_B_SEL;
    
    output en_mem_write;
    
    wire SETWRITE;
    assign SETWRITE = execute & t0 & I_STA;
    wire CLRWRITE;
    assign CLRWRITE = execute & t2 & I_STA;
   wire WRITE;
   
   assign en_mem_write =WRITE;
    jk_ff m_w_ff (
       .clk( clk),
       .j(SETWRITE),
       .k(CLRWRITE),
       .q(WRITE)
       );
    
    wire [15:0] D;
    assign I_NOP = D[0];
    assign I_JMP = D[1];
    assign I_BL = D[2];
    assign I_RET = D[3];
    assign I_LDA = D[4];
    assign I_STA = D[5];
    assign I_ADD = D[6];
    assign I_BAZ = D[7];
    assign I_BAN = D[8];
    wire instr_jump;
    
    wire icynext;
    assign	icynext =
       reset 
       |execute & I_JMP & t0
       |execute & I_NOP & t0
       |execute & I_LDA & t2
       |execute & I_ADD & t2
       |execute & I_STA & t2
       
       ;

    wire new_cycle;
    
    assign instr_jump = I_JMP; // TODO or BL or taken branches
    assign EN_IR = t3 & fetch;
    assign EN_PC = incr_pc | do_jump | reset; 
    assign EN_MA = (t3 & fetch )|
                   (t0 & fetch);
    assign EN_MD = fetch & (t0 | t2)
                    |execute & I_LDA & t1
                    |execute & I_ADD & t1
                    |execute & I_STA & t0
                    ;
    
    assign EN_AC = execute & I_LDA & t2
                   |execute & I_ADD & t2;
    assign do_jump = execute & t0 & instr_jump;
    assign incr_pc = fetch & t2;
    
    system_timing st (
        .reset(reset),
        .clk(clk),
        .icynext(icynext),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3),
        .fetch(fetch),
        .execute(execute),
        .new_cycle(new_cycle)
    );
   REG4CE IR(ir_out, clk, EN_IR, reset, ir_in);
   Decoder4_16Bus instruction_decoder(D, ir_out, ~reset);

   
    assign MA_MUX_SEL = fetch & t3; //TODO document as to why
    assign MD_MUX_SEL = execute & I_STA & t0; //TODO document as to why
    assign AC_MUX_SEL = execute & I_ADD & t2; //TODO document as to why

    assign ALU_MUX_A_SEL = incr_pc; //TODO document as to why
    assign ALU_MUX_B_SEL = incr_pc; //TODO document as to why
endmodule
