`timescale 1ns / 1ps
module ROM_from_file (ADDRESS, VALUE);
 input  [7:0]ADDRESS; 
 output [15:0] VALUE;
 reg    [15:0]rom[0:15]; 
 integer i;

initial begin
        $readmemb("rom.txt", rom);
              for(i = 0; i < 16; i = i + 1)
              $display("memory[%d] = %b", i[7:0], rom[i]);
           end
assign VALUE = rom[ADDRESS];
endmodule
