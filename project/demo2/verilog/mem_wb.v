/*
   CS/ECE 552 Spring '22
  
   Filename        : mem_wb.v
   Description     : This is the module for transiting from memory to write back stage
*/
`default_nettype none
module mem_wb(
	clk, rst, nop_m, nop_w, halt_m, Rd_m, Rd_wb, RegWrite_m, RegWrite_wb,
	MemtoReg_m, exResult_m, memResult_m,
	MemtoReg_w, exResult_w, memResult_w, halt_w
);
	input wire clk, rst, nop_m, halt_m, RegWrite_m;
	input wire MemtoReg_m;
	input wire [15:0] exResult_m, memResult_m;
	input wire [2:0] Rd_m;	
	output wire MemtoReg_w, halt_w, nop_w, RegWrite_wb;
	output wire [15:0] exResult_w, memResult_w;
	output wire [2:0] Rd_wb;


	dff iDFF0 (.q(MemtoReg_w), .d(MemtoReg_m), .clk(clk), .rst(rst));
	dff iDFF1 [15:0] (.q(exResult_w), .d(exResult_m), .clk(clk), .rst(rst));
	dff iDFF2 [15:0] (.q(memResult_w), .d(memResult_m), .clk(clk), .rst(rst));
	dff iDFF3 (.q(halt_w), .d(halt_m), .clk(clk), .rst(rst));

	dff iDFF4 (.q(nop_w), .d(nop_m), .clk(clk), .rst(rst));

	dff iDFF5 		(.q(RegWrite_wb), .d(RegWrite_m), .clk(clk), .rst(rst));
	dff iDFF6 [2:0]  (.q(Rd_wb), .d(Rd_m), .clk(clk), .rst(rst));
	
endmodule
`default_nettype wire