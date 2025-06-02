`timescale 1ns / 1ps
module input_device(
     input [4:0] address,
     input [5:0] control,
     output reg [15:0] value,
     output reg grab_bus
     );
    always @(address)
 if (address == 7) begin
    value <= 16'hbeef;
    grab_bus <= 1'b1;
   end else begin
    value <= 16'bz;
    grab_bus <= 1'b0;
  end
endmodule