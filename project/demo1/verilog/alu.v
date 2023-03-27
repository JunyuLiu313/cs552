/*
   CS/ECE 552 Spring '22
  
   Filename        : alu.v
   Description     : This is the module for the ALU opeartion for R-format instructions
*/

`default_nettype none
module alu(Rs, Rt, instr, op, Rd);

	input wire [15:0] Rs, Rt;
	input wire [4:0] instr;
	input wire [1:0] op;
	output wire[15:0] Rd;

endmodule
`default_nettype wire
