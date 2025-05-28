`timescale  100 ps / 10 ps
module Decoder4_16(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, A, E);
    

   output D0;
   output D1;
   output D2;
   output D3;
   output D4;
   output D5;
   output D6;
   output D7;
   output D8;
   output D9;
   output D10;
   output D11;
   output D12;
   output D13;
   output D14;
   output D15;

   input  [3:0] A;
   input  E;
  
   reg D0;
   reg D1;
   reg D2;
   reg D3;
   reg D4;
   reg D5;
   reg D6;
   reg D7;
   reg D8;
   reg D9;
   reg D10;
   reg D11;
   reg D12;
   reg D13;
   reg D14;
   reg D15;

      always @ (A or E)
      begin
         if(!E)
           {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0000_0000;
        else
        begin
           case(A)
             4'b0000 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0000_0001;
             4'b0001 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0000_0010;
             4'b0010 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0000_0100;
             4'b0011 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0000_1000;
             4'b0100 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0001_0000;
             4'b0101 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0010_0000;
             4'b0110 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_0100_0000;
             4'b0111 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0000_1000_0000;
             4'b1000 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0001_0000_0000;
             4'b1001 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0010_0000_0000;
             4'b1010 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_0100_0000_0000;
             4'b1011 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0000_1000_0000_0000;
             4'b1100 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0001_0000_0000_0000;
             4'b1101 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0010_0000_0000_0000;
             4'b1110 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b0100_0000_0000_0000;
             4'b1111 :  {D15, D14, D13, D12, D11, D10, D9, D8, D7, D6, D5, D4, D3, D2, D1, D0} <= 16'b1000_0000_0000_0000;
          endcase
        end
     end 

endmodule
