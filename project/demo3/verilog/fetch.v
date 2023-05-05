/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (
				newPC, INSTR, clk, rst, incPC, branchTaken, stall, err,
				done, cacheHit, stall_mem,
				stall_data_mem
			);
	input wire [15:0] newPC;
	input wire clk, rst, branchTaken, stall;

	output wire [15:0] INSTR;
	/*output*/ wire [15:0]currPC;	
	output wire [15:0] incPC;
	output wire err;

	// memory signals
	output wire done, cacheHit;
	output wire stall_mem;
	input wire stall_data_mem;

	wire [15:0] PC_i, PC_stall, PCinc_i;
	wire stall_imem;
	assign PCinc_i = currPC;
	cla16b iCLA0	(.sum(incPC), .cOut(), .inA(PCinc_i), .inB(16'h0002), .cIn(1'b0));
	
	assign PC_stall = (stall | stall_mem | stall_data_mem) ? currPC : incPC;
	// assign PC_stall = (stall | stall_data_mem) ? currPC : incPC;
	assign PC_i = branchTaken ? newPC : PC_stall;

	dff PCReg [15:0] (.q(currPC), .d(/*stall_mem ? currPC : */PC_i), .clk(clk), .rst(rst));

	// change the memory
	// memory2c_align 	IMEM 	(.data_out(INSTR), .data_in(16'b0), .addr(currPC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst), .err(err));

	// stall memory
	// when stalling, the instruction should also remains the same
	mem_system IMEM (.DataOut(INSTR), .Done(done), .Stall(stall_imem), .CacheHit(cacheHit), .err(err), .Addr(currPC), .DataIn(16'h0), .Rd(1'b1), .Wr(1'b0), .createdump(branchTaken), .clk(clk), .rst(rst | branchTaken));

	assign stall_mem = ~done; // when I$ is done, we should proceed -- otherwise we are in the middle of a request, so we should stall
	
endmodule
`default_nettype wire