/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (
	// inputs
	OPCODE, Rs, Rt, Imm, PC, FUNC, halt, nop, JR, jump, SIIC, RTI, savePC,
	// outputs
	nxtPC, Result, err);

   // TODO: Your code here
	input wire [4:0] OPCODE;
	input wire [15:0] Rs, Rt, Imm, PC;
	input wire [1:0] FUNC;
	input wire halt, nop, SIIC, RTI, JR, jump, savePC;
	
	output wire [15:0] Result, nxtPC;
	output wire err;
	
	//	logic for updating PC and hadling exception
	wire [15:0] incPC, incPC_i, updPC, Imm_i, aluResult;
	wire branch;
	cla16b PC_INC( .sum(incPC_i), .cOut(), .inA(PC), .inB(16'b0000000000000010), .cIn(1'b0));
	assign incPC = JR | RTI ? Rs : incPC_i;
	assign Imm_i = jump | branch ? Imm : 16'b0; 
	cla16b PC_UPD(.sum(updPC), .cOut(), .inA(incPC), .inB(Imm_i));
	assign nxtPC = SIIC ? 16'b0000000000000010 : updPC;  
	assign Result = savePC ? incPC_i : aluResult; 

   
endmodule
`default_nettype wire