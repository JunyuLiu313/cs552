/*
   CS/ECE 552 Spring '22
  
   Filename        : alu.v
   Description     : This is the module for the ALU opeartion for R-format instructions
*/

`default_nettype none
module alu(Rs, Rt, instr, op, Rd, err);

	input wire [15:0] Rs, Rt;
	input wire [4:0] instr;
	input wire [1:0] op;
	output wire[15:0] Rd;
	output wire err;
	

	// Invert Rs or Rt before operation if needed
	wire [15:0] InRs, InRt;
	assign InRs = (op[0]) ? ~Rs : Rs;
	assign InRt = (op[0]) ? ~Rt : Rt;

	// addition operation
	wire [15:0] addResult;
	wire Cout, Cin;
	assign Cin = op[0];
	cla16b adder1(.sum(addResult), .cOut(Cout), .inA(InRs), .inB(Rt), .cIn(Cin));
	
	// and operation
	wire [15:0] andResult;
	assign andResult = Rs & InRt;

	// xor operation
	wire [15:0] xorResult;
	assign xorResult = Rs ^ Rt;

	// mux for selecting the first four instruction from R-format instruction list
	wire [15:0] tempRd;
	assign tempRd = (op[1]) ? ((op[0]) ? andResult : xorResult) : addResult;
	
	// shift operations
	wire [15:0] shiftResult;
	shifter iShifter(.InBS(Rs), .ShAmt(Rt[3:0]), .ShiftOper(op[1:0]), .OutBS(shiftResult));
	
	
	// comparator for Rs and Rt
	wire [15:0] subResult;					// Rt - Rs
	wire [15:0] ofSum;					// Rt + Rs
	wire tempCout, tempCout1;				// store the carry out bit for Rt+Rs
	wire [15:0] seqRd, sltRd, sleRd, scoRd, compareRd;	// temp for Rd
	wire signCompare;
	assign signCompare = (Rs[15] & ~Rt[15]) ? 1'b1 : 1'b0; 
	cla16b adder2(.sum(subResult), .cOut(tempCout1), .inA(~Rs), .inB(Rt), .cIn(1'b1));
	cla16b adder3(.sum(ofSum), .cOut(tempCout), .inA(Rs), .inB(Rt), .cIn(1'b0));
	assign seqRd = (Rs == Rt) ? 16'b1 : 16'b0;
	// assign sltRd = (Rs == Rt) ? 16'b0 : {15'b0, ~subResult[15]};
	// assign sleRd = {15'b0, ~subResult[15]};
	assign sltRd = (Rs == Rt) ? 16'b0 : ((Rs[15] == Rt[15]) ? {15'b0, ~subResult[15]} : {15'b0, signCompare});
	assign sleRd = sltRd | seqRd;
	assign scoRd = (tempCout) ? 16'b1 : 16'b0;
	assign compareRd = (instr[1]) ? ((instr[0]) ? scoRd : sleRd) 
				: ((instr[0]) ? sltRd : seqRd); 

	// BTR instruction
	wire [15:0] btrRd;
	btr iBTR(.Rd(btrRd), .Rs(Rs));

	// finalize Rd value
	assign Rd = 	(instr[2]) ? compareRd :
			(~instr[0]) ? shiftResult :
			(instr[1]) ? tempRd :
			btrRd;

	// check the overflow errors
	wire ov1, ov2;
	// assign ov1 = (inRt[15] == inRs[15]) ? ((addResult[15] != inRs[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign ov2 = (Rt[15] == ~Rs[15]) ? ((ofSum[15] != Rt[15]) ? 1'b1 : 1'b0) : 1'b0;
	assign err = ov2;

	// needed a zero flag for the future
	

endmodule
`default_nettype wire
