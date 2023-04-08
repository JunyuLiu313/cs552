/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_i1.v
   Description     : This is the module for the ALU opeartion for I-format 1 instructions
*/

`default_nettype none
module alu_i2(Rs, Imm, instr, curPC, newPC, writeData, branch, err);
	// inputs
	input wire [15:0] Rs, Imm;
	input wire [4:0] instr;
	input wire [15:0] curPC;
	input wire branch;

	// outputs
	output wire [15:0] newPC;
	output wire [15:0] writeData;
	output wire err;

	wire [15:0] newRs;
	wire [15:0] newR7;
	
	// assign new R7 value for JALR instruction
	cla16b adder1(.sum(newR7), .cOut(), .inA(curPC), .inB(16'h2), .cIn(1'b0));	

	// branch instructions
	wire [15:0] branchTakenPC;		// calculate the PC value when we take the branch
	cla16b adder2(.sum(branchTakenPC), .cOut(), .inA(newR7), .inB(Imm), .cIn(1'b0));	
	wire [15:0] branchPC;			// PC value for branch instructions
	wire [15:0] beqPC, bnePC, bltPC, bgePC;	// PC values for BEQZ, BNEZ, BLTZ, BGEZ
	assign beqPC = (Rs == 16'b0) ? branchTakenPC : newR7;
	assign bnePC = (Rs != 16'b0) ? branchTakenPC : newR7;
	assign bltPC = (Rs[15]) ? branchTakenPC : newR7;
	assign bgePC = (~Rs[15]) ? branchTakenPC : newR7;
	assign branchPC = (instr[1]) ? ((instr[0]) ? bgePC : bltPC)
			: ((instr[0]) ? bnePC : beqPC);
	
		
	// LBI and SLBI instructions
	wire [15:0] shiftRs;
	shifter iShifter(.InBS(Rs), .ShAmt(4'b1000), .ShiftOper(2'b00), .OutBS(shiftRs));
	assign newRs = (instr[1]) ? (shiftRs | Imm) : Imm;

	// choose either Rs or R7 as the output for write data
	assign writeData = (instr[4]) ? newRs : newR7;
	

	// JR and JALR instructions
	wire [15:0] jumpPC;
	cla16b adder3(.sum(jumpPC), .cOut(), .inA(Rs), .inB(Imm), .cIn(1'b0));
	
	// update the PC value
	assign newPC = (branch) ? branchPC : jumpPC;

	// check for the overflow error
	wire ov1, ov2, ov3;
	assign ov1 = (~curPC[15]) ? ((~newR7[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign ov2 = (Imm[15] == newR7[15]) ? ((Imm[15] != branchTakenPC[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign ov3 = (Imm[15] == Rs[15]) ? ((Imm[15] != jumpPC[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign err = (instr == 5'b00111) ? (ov1 | ov3) : ((instr[3]) ? ov2 : ov3);

endmodule
`default_nettype wire
