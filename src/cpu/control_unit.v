`timescale 1ns / 1ps

module control_unit(clk, reset, fetch, execute, 
                    t0, t1, t2, t3,
                    I_JMP, I_NOP, I_BL, I_RET, I_LDA, I_STA, I_ADD, I_BAN, I_BAZ, I_DIO,
                    incr_pc, do_jump,
                     EN_IR, EN_PC, EN_MA, EN_MD, EN_AC,
                     ir_out, ir_in,
                     MA_MUX_SEL, MD_MUX_SEL, AC_MUX_SEL, ALU_MUX_A_SEL, ALU_MUX_B_SEL,
                     en_mem_write,
                     AN, AZ,
                     ac_out,
                     DATA_BUS_IN,
                     DATA_BUS_OUT,
                     DEVADDRESS,
                     DEVCTRL,
                     md_out,
                     OUTP,INP,
                     RUN_MODE, RUN_CY,
                     pushbutton,
                     LOAD_SW, WRITE_SW, READ_SW, RUN_SW,
                     CONCY1, CONCY2,
                     do_load,
                     do_read,
                     do_write
                    );
    input clk;
    input reset;
    input [4:0] ir_in;
    output [4:0] ir_out;
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
    output I_DIO;
    
    
    output incr_pc;
    output do_jump;
    
    output EN_IR;
    output EN_PC;
    output EN_MA;
    output EN_MD;
    output EN_AC;
    
    output [1:0]MA_MUX_SEL;
    output [1:0] MD_MUX_SEL;
    output [1:0] AC_MUX_SEL;
    output ALU_MUX_A_SEL;
    output ALU_MUX_B_SEL;
    
    output en_mem_write;
    
    input AN;
    input AZ;
    
    input [15:0] ac_out;
    input [15:0] DATA_BUS_IN; // TODO: move to datapath
    output [15:0] DATA_BUS_OUT; // TODO: move to datapath
    output [4:0] DEVADDRESS;
    output [5:0] DEVCTRL;
    input [15:0] md_out;
    output OUTP, INP;
    input RUN_MODE;
    input RUN_CY;
    input pushbutton;
    input LOAD_SW, WRITE_SW, READ_SW, RUN_SW;
    input CONCY1, CONCY2;
    
    output do_load;
    output do_read;
    output do_write;
  
    assign DEVADDRESS=md_out[4:0];
    assign DEVCTRL=md_out[9:5];
    
    wire RUN;
    assign RUN = RUN_MODE;
    wire INPUT;
    wire OUTPUT;
    wire IO;
    assign IO = ir_out[0];
    
    assign INPUT = I_DIO & IO & RUN;
    assign OUTPUT = I_DIO & ~IO & RUN;
    
    wire SETOUTP;
    assign SETOUTP = execute & I_DIO & OUTPUT & t0;
    wire SETINP;
    assign SETINP = execute & I_DIO & INPUT & t0;
    
    
    wire CLROUTP, CLRINP;
    
    assign CLROUTP = execute & I_DIO & t3;
    assign CLRINP = execute & I_DIO & t3;
    jk_ff out_ff (
       .clk( clk),
       .j(SETOUTP),
       .k(CLROUTP),
       .q(OUTP)
       );
    jk_ff inp_ff (
       .clk( clk),
       .j(SETINP),
       .k(CLRINP),
       .q(INP)
       );
       
       
  
    reg [15:0] io_internal;
    wire [15:0] not_ac;
    wire [15:0] incoming_io_bus;
    assign incoming_io_bus = DATA_BUS_IN;
    assign not_ac = ~ac_out; 
    always @(*)
       io_internal <= OUTP?ac_out:16'bz;

    assign DATA_BUS_OUT = io_internal;
    wire stop_write;
    wire stop_read;
    wire SETWRITE;
    assign SETWRITE = execute & t0 & I_STA |do_write;
    wire CLRWRITE;
    assign CLRWRITE = execute & t2 & I_STA|stop_write;
       wire button_triggered;
    assign do_load = button_triggered & LOAD_SW;
    assign do_read = button_triggered & READ_SW;
    assign do_write = button_triggered & WRITE_SW;    

    jk_ff m_w_ff (
       .clk( clk),
       .j(SETWRITE),
       .k(CLRWRITE),
       .q(en_mem_write)
       );
    
    wire [15:0] D;
    assign I_NOP = D[0];
    assign I_JMP = D[1];
    assign I_BL  = D[2];
    assign I_RET = D[3];
    assign I_LDA = D[4];
    assign I_STA = D[5];
    assign I_ADD = D[6];
    assign I_BAZ = D[7];
    assign I_BAN = D[8];
    // 9 SUB?
    // 10 INC, DEC, ASL, ASR, ROL, ROR, ...
    // 11 
    // 12
    // 13 RTI?
    // 14
    assign I_DIO = D[15];
    wire instr_jump;
    
    wire icynext;
    assign	icynext =
       reset 
       |execute & I_JMP & t0
       |execute & I_BAN & t0
       |execute & I_BAZ & t0
       |execute & I_NOP & t0
       |execute & I_LDA & t2
       |execute & I_ADD & t2
       |execute & I_STA & t2
       ;

    wire new_cycle;
    
    assign instr_jump = I_JMP | (I_BAN & AN) | (I_BAZ & AZ); // TODO or BL
    assign EN_IR = (t3 & fetch) ;
    assign do_jump = execute & t0 & instr_jump;
    assign EN_PC = incr_pc | do_jump | reset | do_load; 
    assign EN_MA = fetch & t0 
                  |fetch & t3
                  |do_load
                  |do_write
                  |do_read
                   ;
    assign EN_MD = fetch & (t0 | t2)
                  |execute & I_LDA & t1
                  |execute & I_ADD & t1
                  |execute & I_STA & t0
                  |do_write
                  |do_read
                ;

     assign EN_AC = execute & I_LDA & t2
                   |execute & I_ADD & t2
                   |execute & INPUT & t2
                   |do_load
                   |do_write
                   |stop_read
                   ;
      assign incr_pc = fetch & t2|stop_write|stop_read;
    
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
        .new_cycle(new_cycle),
        .RUN_MODE(RUN_MODE),
        .RUN_CY(RUN_CY)
    );
    reg5ce IR(ir_out, clk, EN_IR, reset, ir_in);
    wire [3:0] i_decoder_in;
    assign i_decoder_in = ir_out[4:1];
    Decoder4_16Bus instruction_decoder(D, i_decoder_in, 1'b1);

     
    assign MA_MUX_SEL = (fetch & t0)|do_write|do_read ? 2'b00 : 
                        fetch & t3 ? 2'b01 :
                           do_load ? 2'b10 :
                                     2'b11
                        ; //TODO document as to why
    assign MD_MUX_SEL = execute & I_STA & t0 ? 2'b01 :
                                    do_write ? 2'b10 :
                                               2'b00 // read from memory  
    
    ; //TODO document as to why
    assign AC_MUX_SEL = execute & I_ADD & t2 ? 2'b01: 
                        execute & INPUT & t2 ? 2'b10:
                          do_write | do_load ? 2'b11:
                                               2'b00 
    ; //TODO document as to why

    assign ALU_MUX_A_SEL = incr_pc; //TODO document as to why
    assign ALU_MUX_B_SEL = incr_pc; //TODO document as to why
    
       pulser trigger_button(
       .pulser(pushbutton),
       .clk(clk),
       .o(button_triggered)
    );
    wire write_delay;
       pulser write1(
       .pulser(do_write),
       .clk(clk),
       .o(write_delay)
    );
       pulser write2(
       .pulser(write_delay),
       .clk(clk),
       .o(stop_write),
       .reset(reset)
    );
    
       wire read_delay;
       pulser read1(
       .pulser(do_read),
       .clk(clk),
       .o(read_delay)
    );
       pulser read2(
       .pulser(read_delay),
       .clk(clk),
       .o(stop_read),
       .reset(reset)
    );
    
endmodule
