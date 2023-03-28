/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (
	// inputs
	opcode, Rs, Rt, Imm, currPC, FUNC, halt, nop, MemRead, MemWrite, MemtoReg, branch,
	// outputs
	writeData, nxtPC, MemAddr, ex_err
);

   // TODO: Your code here
	input wire [4:0] opcode;
	input wire [15:0] Rs, Rt, Imm, currPC;
	input wire [1:0] FUNC;
	input wire halt, nop, MemRead, MemWrite, MemtoReg, branch;
	
	output wire [15:0] writeData, nxtPC, MemAddr;
	output wire ex_err;
	
	// temps for all the writeData from the ALUs
	wire [15:0] r_wData, j_wData, i1_wData, i2_wData;
	wire [15:0] j_PC, i2_PC;
	// wire [15:0] i1_memAddr;
	
	// writeData will be chosen from Rd, updated Rs, or R7
	// The next PC value will either be PC+2 or result from coresponding ALU
	// Memory address will only be calculated from I-1 type instruction
	
	// calling each ALU
	alu r_ALU(.Rs(Rs), .Rt(Rt), .instr(opcode), .op(FUNC), .Rd(r_wData));	// R-type
	alu_i1 i1_ALU(.Rs(Rs), .imm(Imm), .instr(opcode), .Rd(i1_wData), .memAddr(MemAddr), .memRead(MemRead), .memWrite(MemWrite));	// I1-type
	alu_j j_ALU(.instr(opcode), .curPC(currPC), .imm(Imm), .nxtPC(j_PC), .newR7(j_wData));		// J-type
	alu_i2 i2_ALU(.Rs(Rs), .Imm(Imm), .instr(opcode), .curPC(currPC), .newPC(i2_PC), .writeData(i2_wData), .branch(branch));	// I2-type

	// choose the write data from ALUs
	

	// choose the next PC value
	
	
	
	
   
endmodule
`default_nettype wire
