/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (PC, INSTR, nop, clk, rst, currPC);
	input wire [15:0] 	PC;
	input wire 		clk, rst, nop;
	output wire [15:0] 	INSTR;
	output wire [15:0]	currPC;	
	
	wire [15:0] INSTR_imm, currPC_imm;
	
	dff PCReg [15:0] (.q(currPC_imm), .d(PC), .clk(clk), .rst(rst));
	//	Instantiate Instruction memory
	memory2c IMEM (.data_out(INSTR_imm), .data_in(16'b0), .addr(currPC_imm), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
	//	Instantiate IF/ID registers
	if_id IFID(.instr_f(INSTR_imm), .pc_f(currPC_imm), .clk(clk), .rst(rst), .instr_d(INSTR), .pc_d(currPC), .nop(nop));
endmodule
`default_nettype wire
