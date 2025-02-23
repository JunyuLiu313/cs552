/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (newPC, INSTR, clk, rst, incPC, branchTaken, stall);
	input wire [15:0] newPC;
	input wire clk, rst, branchTaken, stall;

	output wire [15:0] INSTR;
	/*output*/ wire [15:0]currPC;	
	output wire [15:0] incPC;

	wire [15:0] PC_i, PC_stall, PCinc_i;
	assign PCinc_i = currPC;
	cla16b iCLA0	(.sum(incPC), .cOut(), .inA(PCinc_i), .inB(16'h0002), .cIn(1'b0));
	
	assign PC_stall = stall ? currPC : incPC;
	assign PC_i = branchTaken ? newPC : PC_stall;

	dff PCReg [15:0] (.q(currPC), .d(PC_i), .clk(clk), .rst(rst));
	memory2c IMEM 	(.data_out(INSTR), .data_in(16'b0), .addr(currPC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
	
endmodule
`default_nettype wire