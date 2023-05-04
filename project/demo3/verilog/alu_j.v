/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_j.v
   Description     : This is the module for the ALU opeartion for J-format instructions
*/

`default_nettype none
module alu_j(instr, curPC, imm, nxtPC, err);
	// concern about R7
	input wire [4:0] instr;
	input wire [15:0] curPC;
	input wire [15:0] imm;
	output wire [15:0] nxtPC;
	// output wire [15:0] newR7;
	output wire err;

	// check for overflow
	wire of1, of2;

	// newR7 = PC + 2
	wire [15:0] newR7;
	assign newR7 = curPC;

	cla16b adder2(.sum(nxtPC), .cOut(), .inA(curPC), .inB(imm), .cIn(1'b0));

	assign of1 = (~curPC[15]) ? ((curPC[15] != newR7[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign of2 = (newR7[15] == imm[15]) ? ((newR7[15] != nxtPC[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign err = of1 | of2;
	

endmodule
`default_nettype wire