/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_i1.v
   Description     : This is the module for the ALU opeartion for I-format 1 instructions
*/

`default_nettype none
module alu_i1(Rs, imm, instr, Rd, memAddr, memRead, memWrite);
	input wire[15:0] Rs, imm;
	input wire [4:0] instr;				// the 5-bit opcode
	output wire [15:0] Rd;				// the write-back data: either Rd or updated Rs

	output wire [15:0] memAddr;			// address for memory

	// how to assign Rs for memory write
	input wire memRead, memWrite;
	

	wire [15:0] inRs = (instr[0]) ? ~Rs : Rs;
	wire [15:0] inImm = (instr[0]) ? ~imm : imm;
	wire [15:0] sumResult, xorResult, andnResult;
	wire cOut;
	// get either ADDI or SUBI instruction result
	cla16b adder1(.sum(sumResult), .cOut(cOut), .inA(imm), .inB(inRs), .cIn(instr[0]));	
	
	assign xorResult = Rs ^ imm;		// XORI result
	assign andnResult = Rs & inImm;		// ANDNI result
	
	// choose the Rd from ADDI, SUBI, XORI, ANDNI
	wire [15:0] operRd = (instr[1]) ? ((instr[0]) ? andnResult : xorResult) : sumResult;

	// shifter instructio result
	wire [15:0] shiftRd;
	shifter iShifter(.InBS(Rs), .ShAmt(imm[3:0]), .ShifterOper({~instr[0], instr[1]}), .OutBS(shiftRd));
	
	// calculate memory address
	wire memCout;
	cla16b adder2(.sum(memAddr), .cOut(memCout), .inA(imm), .inB(Rs), .cIn(1'b0));	

	wire [15:0] newRs;			// updated Rs for STU instruction
	cla16b adder3(.sum(newRs), .cOut(), .inA(imm), .inB(Rs), .cIn(1'b0));	

	// assign Rd value for instructions except those with memory interation
	assign Rd = (instr[4]) ? shiftRd : operRd;
	assign Rd = (instr == 5'b10011) ? newRs : Rd;

endmodule
`default_nettype wire
