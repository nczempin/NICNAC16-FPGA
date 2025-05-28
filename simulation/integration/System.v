`timescale 1ns / 1ps

//This is for ideas/simulation on what to connect to the Basys 3

module System(
    input a
    );
    wire OUTP; //TODO extract from DEVCTRL, presumably
    
     wire out_r_in;
    wire out_r_address_decoded;
   assign out_r_address_decoded = DEVADDRESS == 5'h1c;
   assign out_r_in = ~(out_r_address_decoded & OUTP); //NAND, we are looking for rising edge
  
   NICNAC16 nn16 (
    .clk_fpga(clk),
    .SW(SW),
    .BTN(BTN),
    .LED(LED),
    .SSEG_CA(SSEG_CA),
    .SSEG_AN(SSEG_AN)
   
); 
     input_device id (
 .address(DEVADDRESS),
  .control(DEVCTRL),
     .value(device_out),
     .grab_bus(device_active)
 );
 
    FD16CE out_register(
  .D(IODATA_BUS),
  .Q(latched_data),
  .CE(1'b1),
  .C(out_r_in),
  .CLR(reset)
  );
endmodule
