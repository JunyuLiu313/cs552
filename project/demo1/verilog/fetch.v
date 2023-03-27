/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (PC, INSTR, clk, rst);
	input wire [15:0] PC;
	input wire clk, rst;
	
	output wire [15:0] INSTR;


	// Instantiate dff for PC address
	wire [15:0] tempAddr, updateAddr;
	assign tempAddr = PC;
	dff iDFF[15:0](.q(updateAddr), .d(tempAddr), .clk(clk), .rst(rst));

	//	Instantiate Instruction memory
	memory2c IMEM (.data_out(INSTR), .data_in(16'b0), .addr(updateAddr), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));


	
endmodule
`default_nettype wire
