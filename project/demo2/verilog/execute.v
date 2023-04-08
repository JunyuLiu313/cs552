/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (
	// inputs
	clk, rst, opcode, Rs, Rt, Imm, currPC, FUNC, halt, nop, MemRead, MemWrite, MemtoReg, branch, resultSel,
	// outputs
	writeData, nxtPC, MemAddr, ex_err, branchTaken
);

   // TODO: Your code here
	input wire [4:0] opcode;
	input wire [15:0] Rs, Rt, Imm, currPC;
	input wire [1:0] FUNC, resultSel;
	input wire clk, rst,  halt, nop, MemRead, MemWrite, MemtoReg, branch;
	
	output wire [15:0] writeData, nxtPC, MemAddr;
	output wire ex_err;

	output wire branchTaken;
	
	// temps for all the writeData from the ALUs
	wire [15:0] r_wData, j_wData, i1_wData, i2_wData;
	wire [15:0] j_PC, i2_PC;
	wire r_err, j_err, i1_err, i2_err;
	
	// writeData will be chosen from Rd, updated Rs, or R7
	// The next PC value will either be PC+2 or result from coresponding ALU
	// Memory address will only be calculated from I-1 type instruction
	
	// calling each ALU
	alu r_ALU(.Rs(Rs), .Rt(Rt), .instr(opcode), .op(FUNC), .Rd(r_wData), .err(r_err));								// R-type
	alu_i1 i1_ALU(.Rs(Rs), .imm(Imm), .instr(opcode), .Rd(i1_wData), .memAddr(MemAddr), .memRead(MemRead), .memWrite(MemWrite), .err(i1_err));	// I1-type
	alu_j j_ALU(.instr(opcode), .curPC(currPC), .imm(Imm), .nxtPC(j_PC), .newR7(j_wData), .err(j_err));						// J-type
	alu_i2 i2_ALU(.Rs(Rs), .Imm(Imm), .instr(opcode), .curPC(currPC), .newPC(i2_PC), .writeData(i2_wData), .branch(branch), .err(i2_err));		// I2-type

	/*
	  choose the write data from ALUs
		resultSel:	00 -> R-type
				01 -> I1-type
				10 -> I2-type
				11 -> J-type
	*/
	assign writeData = (resultSel[1]) ? ((resultSel[0]) ? j_wData : i2_wData) : ((resultSel[0]) ? i1_wData : r_wData);

	// choose the next PC value
	wire [15:0] normalPC;
	cla16b adder1(.sum(normalPC), .cOut(), .inA(currPC), .inB(16'h2), .cIn(1'b0));
	// assign nxtPC = (resultSel[1]) ? ((resultSel[0]) ? j_PC : i2_PC) : normalPC;
	// assign nxtPC = (~opcode[4] & opcode[2]) ? ((opcode[3]) ? i2_PC : j_PC) : normalPC;
	// assign branchTaken = (resultSel == 2'b11) ? 1'b1 : ((resultSel == 2'b10) ? ((~opcode[4]) ? 1'b1 : 1'b0) : 1'b0);
	
	assign nxtPC = (resultSel == 2'b11) ? j_PC : ((resultSel == 2'b10) ? ((~opcode[4]) ? i2_PC : normalPC) : normalPC);
	wire branchDetect;
	assign branchDetect = (~opcode[4] & opcode[3] & opcode[2]) ? 1'b1 : ((~opcode[4] & ~opcode[3] & opcode[2]) ? 1'b1 :1'b0);
	//assign branchTaken = (branchDetect) ? ((nxtPC != normalPC) ? 1'b1 : 1'b0) : 1'b0;
	assign branchTaken = (nxtPC != normalPC) ? 1'b1 : 1'b0;
	// assign branchTaken = 1'b0;
	// chooose the error signal
	assign ex_err = (resultSel[1]) ? ((resultSel[0]) ? j_err : i2_err) : ((resultSel[0]) ? i1_err : r_err);
   
endmodule
`default_nettype wire
