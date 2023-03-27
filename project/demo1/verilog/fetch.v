/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (PC, INSTR, clk, rst, currPC);
	input wire [15:0] 	PC;
	input wire 			clk, rst;
	
	output wire [15:0] 	INSTR;
	output reg [15:0]	currPC;	

	dff PCReg [15:0] (.q(currPC), .d(PC), .clk(clk), .rst(rst));
	//	Instantiate Instruction memory
	memory2c IMEM (.data_out(INSTR), .data_in(16'b0), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
	
endmodule
`default_nettype wire
