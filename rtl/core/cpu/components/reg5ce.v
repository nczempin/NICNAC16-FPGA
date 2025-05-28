`timescale 1ns / 1ps

module reg5ce(Q, C, CE, CLR, D);

   
   output reg [4:0]      Q;

   input 	      C;	
   input 	      CE;	
   input 	      CLR;	
   input  [4:0]      D;
  
     
   always @(posedge C or posedge CLR)
     begin
	if (CLR)
	  Q <= 5'b00000;
	else if (CE)
          Q <= D;
     end
   
   
endmodule