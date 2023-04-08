/*
   CS/ECE 552 Spring '22
  
   Filename        : mem_wb.v
   Description     : This is the module for transiting from memory to write back stage
*/
`default_nettype none
module mem_wb(
	clk, rst, stall, nop_m, nop_w, halt_m, Rd_m, Rd_wb, RegWrite_m, RegWrite_wb,
	MemtoReg_m, exResult_m, memResult_m,
	MemtoReg_w, exResult_w, memResult_w, halt_w
);
	input wire clk, rst, stall, nop_m, halt_m, RegWrite_m;
	input wire MemtoReg_m;
	input wire [15:0] exResult_m, memResult_m;
	input wire [2:0] Rd_m;	
	output wire MemtoReg_w, halt_w, nop_w, RegWrite_wb;
	output wire [15:0] exResult_w, memResult_w;
	output wire [2:0] Rd_wb;


	wire MemtoReg, halt, RegWrite;
	wire [2:0] Rd;
	wire [15:0] exResult, memResult;

 	assign MemtoReg = 	(stall) ? MemtoReg_w : MemtoReg_m;
	assign exResult = 	(stall)? exResult_w : exResult_m;
	assign memResult = 	(stall)? memResult_w : memResult_m;
	assign Rd = 		(stall)? Rd_wb : Rd_m;
	assign RegWrite = 	(stall)? RegWrite_wb : RegWrite_m;
	assign halt = 		(stall) ? halt_w : halt_m;

	dff iDFF0 (.q(MemtoReg_w), .d(MemtoReg), .clk(clk), .rst(rst));
	dff iDFF1 [15:0] (.q(exResult_w), .d(exResult), .clk(clk), .rst(rst));
	dff iDFF2 [15:0] (.q(memResult_w), .d(memResult), .clk(clk), .rst(rst));
	dff iDFF3 (.q(halt_w), .d(halt), .clk(clk), .rst(rst));

	dff iDFF4 (.q(nop_w), .d(nop_m), .clk(clk), .rst(rst));

	dff iDFF5 		(.q(RegWrite_wb), .d(RegWrite), .clk(clk), .rst(rst));
	dff iDFF6 [2:0]  (.q(Rd_wb), .d(Rd), .clk(clk), .rst(rst));
	
endmodule
`default_nettype wire