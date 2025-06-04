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
   always @(din or le) 
     if (le == 1'b1) 
       dout <= din;   //Use non-blocking
     else
       dout <= 0;
    
endmodule // latch
