`timescale 10ns / 1ps

module NICNAC16_tb ();
    reg clk, reset;

    reg [15:0] SW;
    wire [4:0] BTN;
//assign BTN = {reset,4'b0000};
    wire [15:0] LED;
    wire [7:0]SSEG_CA;
    wire [3:0]SSEG_AN;

    reg [1:0] knob_setting;
    reg pushbutton;
    reg [7:0] JA;
wire btnC, btnU, btnL, btnR, btnD;
assign btnC = reset;
assign BTN={btnC, btnU, btnL, btnR, btnD};

wire clk_external;
assign clk_external = JA[0];
NICNAC16 nn16 (
    .clk(clk),
    .sw(SW),
    .btnC(btnC),
    .btnU(btnU),
    .btnL(btnL),
    .btnR(btnR),
    .btnD(btnD),
    .knob_setting(knob_setting), //TODO map to buttons
    .pushbutton(pushbutton), //TODO map to buttons
    .led(LED),
    .JA(JA)
);

initial begin
    clk=1;
 JA= 8'b00000000;
    pushbutton =1'b1; 
   knob_setting =2'b00;
   reset =1'b0;
   #1
	reset = 1'b1;
	SW = 16'haced;
	
		#20
	reset = 1'b0;
	// reset done
	
	#3
	pushbutton <= 1'b0;
	#3
    pushbutton =1'b1; 
    #3
    
  
	
	
	// RUN MODE
	 knob_setting =2'b00;
	 
#32

 knob_setting =2'b00;
end
always #0.5 clk =~clk;
always #20 JA[0] = ~JA[0];

//always #700 enable =~ enable; 

    
endmodule
