/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (addr, inputA, inputB, instr, out, imm, newAddr, Opcode);

   // TODO: Your code here
	input wire [15:0] inputA, inputB, addr, imm;
	input wire [4:0] instr;
	input wire [1:0] Opcode;
	output wire [15:0] out, newAddr;

	// update the PC value
	
   
endmodule
`default_nettype wire
