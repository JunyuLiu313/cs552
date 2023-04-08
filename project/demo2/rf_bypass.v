/*
   CS/ECE 552, Spring '23
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
`default_nettype none
module rf_bypass (
                  // Outputs
                  read1OutData, read2OutData, err,
                  // Inputs
                  clk, rst, read1RegSel, read2RegSel, writeRegSel, writeInData, writeEn
                  );
   parameter REGISTER_WIDTH = 16; 
   input wire       clk, rst;
   input wire [2:0] read1RegSel;
   input wire [2:0] read2RegSel;
   input wire [2:0] writeRegSel;
   input wire [REGISTER_WIDTH-1:0] writeInData;
   input wire        writeEn;

   output wire [REGISTER_WIDTH-1:0] read1OutData;
   output wire [REGISTER_WIDTH-1:0] read2OutData;
   output wire        err;

   /* YOUR CODE HERE */
	wire [REGISTER_WIDTH-1:0] temp1, temp2;
	rf irf(.clk(clk), .rst(rst), .writeEn(writeEn), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel),
			.writeRegSel(writeRegSel), .writeInData(writeInData), .read1OutData(temp1), .read2OutData(temp2), .err(err));
	assign read1OutData = temp1; //(writeEn) ? ((read1RegSel == writeRegSel) ? writeInData : temp1) : temp1;
	assign read2OutData = temp2; //(writeEn) ? ((read2RegSel == writeRegSel) ? writeInData : temp2) : temp2;

endmodule
`default_nettype wire
