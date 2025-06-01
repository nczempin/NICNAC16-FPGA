`timescale 1ns / 1ps


module Memory(
    input clk,
    input en_mem_write,
    output [15:0] mem_read,
    input [15:0] mem_write,
    input [15:0] mem_address
    );
    
    wire [15:0] rom_out;
    wire [7:0] rom_address;
    
    wire rom_or_ram;
    assign rom_or_ram = mem_address[8];
    
    wire [7:0] ram_address;
    
    assign ram_address = mem_address[7:0];
    assign rom_address = mem_address[7:0];
    wire ram_write;
    assign ram_write=en_mem_write & ~rom_or_ram;
    wire [15:0] ram_in;
    assign ram_in = mem_write;
    wire [15:0] ram_out;
    
    assign mem_read = rom_or_ram ? rom_out : ram_out;
    RAM ram (
		.ADDRESS(ram_address), 
		.IN(ram_in), 
		.WRITE(ram_write), 
		.CLK(clk), 
		.OUT(ram_out)
	);
    
    ROM rom(
        .address(rom_address),
        .data(rom_out)
    );
endmodule
