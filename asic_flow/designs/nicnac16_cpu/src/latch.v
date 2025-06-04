`timescale 1ns / 1ps
module latch( 
   // Outputs 
   dout, 
   // Inputs 
   din, le 
   ); 
   input din; 
   output dout; 
   input  le; // latch enable 
   reg dout; 
   always @(*) 
     if (le == 1'b1) 
       dout = din;   //Use blocking for combinational
     else
       dout = 0;
    
endmodule // latch
