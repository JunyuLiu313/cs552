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
	
	
	
   
endmodule
`default_nettype wire
