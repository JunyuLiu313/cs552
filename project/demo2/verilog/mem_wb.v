/*
   CS/ECE 552 Spring '22
  
   Filename        : mem_wb.v
   Description     : This is the module for transiting from memory to write back stage
*/
`default_nettype none
module mem_wb(
	clk, rst, nop, MemtoReg_m, exResult_m, memResult_m,
	MemtoReg_w, exResult_w, memResult_w
);
	input wire clk, rst, nop;
	input wire MemtoReg_m;
	input wire [15:0] exResult_m, memResult_m;
	
	output wire MemtoReg_w;
	output wire [15:0] exResult_w, memResult_w;

	wire MemtoReg;
	wire [15:0] exResult, memResult;

	assign MemtoReg = nop ? MemtoReg_w : MemtoReg_m;
	assign exResult = nop ? exResult_w : exResult_m;
	assign memResult = nop ? memResult_w : memResult_m;

	dff iDFF0 (.q(MemtoReg_w), .d(MemtoReg), .clk(clk), .rst(rst));
	dff iDFF1 [15:0] (.q(exResult_w), .d(exResult), .clk(clk), .rst(rst));
	dff iDFF2 [15:0] (.q(memResult_w), .d(memResult), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
