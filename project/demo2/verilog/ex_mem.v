/*
   CS/ECE 552 Spring '22
  
   Filename        : ex_mem.v
   Description     : This is the module for transiting from excuete to memory stage
*/
`default_nettype none
module ex_mem(
    clk, rst, nop, Addr_x, writeData_x, halt_x, MemWrite_x, MemRead_x, Rt_x, MemToReg_x,
    Addr_m, WriteData_m, halt_m, MemWrite_m, MemRead_m, Rt_m, MemtoReg_m
);
    input wire clk, rst, nop;
    input wire [15:0] Addr_x, writeData_x, Rt_x;
    input wire halt_x, MemWrite_x, MemRead_x,MemToReg_x;

    output wire [15:0] Addr_m, WriteData_m, Rt_m;
    output wire halt_m, MemWrite_m, MemRead_m, MemtoReg_m;

    wire [15:0] Addr, WriteData, rt;
    wire halt, MemWrite, MemRead, MemtoReg;

    assign Addr = nop ? Addr_m : Addr_x;
    assign WriteData = nop ? WriteData_m : writeData_x;
    assign rt = nop ? Rt_m : Rt_x;
    assign halt = nop ? halt_m : halt_x;
    assign MemWrite = nop ? MemWrite_m : MemWrite_x;
    assign MemRead = nop ? MemRead_m : MemRead_x;
    assign MemtoReg = nop ? MemtoReg_m : MemToReg_x;

	dff iDFF0 [15:0] (.q(Addr_m), .d(Addr), .clk(clk), .rst(rst)); 
	dff iDFF1 [15:0] (.q(WriteData_m), .d(WriteData), .clk(clk), .rst(rst)); 
	dff iDFF2 [15:0] (.q(Rt_m), .d(rt), .clk(clk), .rst(rst)); 
	dff iDFF3 (.q(halt_m), .d(halt), .clk(clk), .rst(rst)); 
	dff iDFF4 (.q(MemWrite_m), .d(MemWrite), .clk(clk), .rst(rst)); 
	dff iDFF5 (.q(MemRead_m), .d(MemRead), .clk(clk), .rst(rst)); 
    dff iDFF6 (.q(MemtoReg_m), .d(MemtoReg), .clk(clk), .rst(rst)); 

endmodule
`default_nettype wire
