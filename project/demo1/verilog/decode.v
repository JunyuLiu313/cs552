/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (INSTR, Rs, Rt, Rd, Opcode, imm);

	// TODO: Your code here
	input wire [15:0] INSTR;
   
	output wire [2:0] Rs, Rt, Rd;
	output wire [4:0] Opcode;
	output wire [10:0] imm;
   
	assign Opcode 	= INSTR[15:11];
	assign Rs 		= INSTR[10:8];
	assign Rt 		= INSTR[7:5];
	assign Rd 		= (INSTR[15] & INSTR[14]) ? INSTR[4:2] : INSTR[7:5];
	assign imm 		= INSTR[10:0];
	
endmodule
`default_nettype wire
