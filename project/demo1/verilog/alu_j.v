/*
   CS/ECE 552 Spring '22
  
   Filename        : alu_j.v
   Description     : This is the module for the ALU opeartion for J-format instructions
*/

`default_nettype none
module alu_j(instr, curPC, imm, nxtPC, R7, newR7);
	// concern about R7
	input wire [4:0] instr;
	input wire [15:0] curPC, R7;
	input wire [15:0] imm;
	output wire [15:0] nxtPC;
	output wire [15:0] newR7;

	wire[15:0] temp;		// temp = PC + 2
	cla16b adder1(.sum(temp), .cOut(), .inA(curPC), .inB(16'h2), .cIn(1'b0));
	cla16b adder2(.sum(nxtPC), .cOut(), .inA(temp), .inB(imm), .cIn(1'b0));	
	assign newR7 = (instr[1]) ? temp : R7;

endmodule
`default_nettype wire
