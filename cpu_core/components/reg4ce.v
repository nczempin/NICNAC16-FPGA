`timescale 100 ps / 10 ps

module REG4CE(Q, C, CE, CLR, D);

   
   output [3:0]      Q;

   input 	      C;	
   input 	      CE;	
   input 	      CLR;	
   input  [3:0]      D;
   
   reg    [3:0]      Q;
   
   always @(posedge C or posedge CLR)
     begin
	if (CLR)
	  Q <= 4'b0000;
	else if (CE)
          Q <= D;
     end
   
   
endmodule