/*
   CS/ECE 552 Spring '22
  
   Filename        : ex_mem.v
   Description     : This is the module for transiting from excuete to memory stage
*/
`default_nettype none
module ex_mem(
    clk, rst, nop, Addr_e, WriteData_e, halt_d, MemWrite_d, MemRead_d, rt_e,
    Addr_m, WriteData_m, halt_m, MemWrite_m, MemRead_m, rt_m
);
    input wire clk, rst, nop;
    input wire [15:0] Addr_e, WriteData_e, rt_e;
    input wire halt_d, MemWrite_d, MemRead_d;

    output wire [15:0] Addr_m, WriteData_m, rt_m;
    output wire halt_m, MemWrite_m, MemRead_m;

    wire [15:0] Addr, WriteData, rt;
    wire halt, MemWrite, MemRead;

    assign Addr = nop ? Addr_m : Addr_e;
    assign WriteData = nop ? WriteData_m : WriteData_e;
    assign rt = nop ? rt_m : rt_e;
    assign halt = nop ? halt_m : halt_d;
    assign MemWrite = nop ? MemWrite_m : MemWrite_d;
    assign MemRead = nop ? MemRead_m : MemRead_d;

	dff iDFF0 [15:0] (.q(Addr_m), .d(Addr), .clk(clk), .rst(rst)); 
	dff iDFF1 [15:0] (.q(WriteData_m), .d(WriteData), .clk(clk), .rst(rst)); 
	dff iDFF2 [15:0] (.q(rt_m), .d(rt), .clk(clk), .rst(rst)); 
	dff iDFF3 (.q(halt_m), .d(halt), .clk(clk), .rst(rst)); 
	dff iDFF4 (.q(MemWrite_m), .d(MemWrite), .clk(clk), .rst(rst)); 
	dff iDFF5 (.q(MemRead_m), .d(MemRead), .clk(clk), .rst(rst)); 

endmodule
`default_nettype wire
