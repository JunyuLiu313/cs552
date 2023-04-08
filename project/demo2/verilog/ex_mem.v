/*
   CS/ECE 552 Spring '22
  
   Filename        : ex_mem.v
   Description     : This is the module for transiting from excuete to memory stage
*/
`default_nettype none
module ex_mem(
    clk, rst, stall_x, stall_m, nop_x, nop_m, Rd_x, Rd_m, RegWrite_x, RegWrite_m,
    Addr_x, writeData_x, halt_x, MemWrite_x, MemRead_x, Rt_x, MemToReg_x, nxtPC_x, branchTaken_x,
    Addr_m, WriteData_m, halt_m, MemWrite_m, MemRead_m, Rt_m, MemToReg_m, nxtPC_m, branchTaken_m
);
    input wire clk, rst, nop_x, RegWrite_x, stall_x;
    input wire [15:0] Addr_x, writeData_x, Rt_x, nxtPC_x;
    input wire halt_x, MemWrite_x, MemRead_x,MemToReg_x, branchTaken_x;
    input wire [2:0] Rd_x;

    output wire [15:0] Addr_m, WriteData_m, Rt_m, nxtPC_m;
    output wire halt_m, MemWrite_m, MemRead_m, MemToReg_m, branchTaken_m, stall_m;
    output wire nop_m, RegWrite_m;
    output wire [2:0] Rd_m;

    wire [15:0] Addr, WriteData, rt, nxtPC;
    wire halt, MemWrite, MemRead, MemtoReg, branchTaken;
    wire [2:0] Rd;
    wire RegWrite;

    assign Addr = (stall_x) ? Addr_m : Addr_x;
    assign WriteData = (stall_x) ? WriteData_m : writeData_x;
    assign Rd = (stall_x) ? Rd_m : Rd_x;
    assign RegWrite = (stall_x) ? RegWrite_m : RegWrite_x;    
    assign rt = (stall_x) ? Rt_m : Rt_x;
    assign halt = (stall_x) ? halt_m : halt_x;
    assign MemWrite = (stall_x) ? MemWrite_m : MemWrite_x;
    assign MemRead = (stall_x) ? MemRead_m : MemRead_x;
    assign MemtoReg = (stall_x) ? MemToReg_m : MemToReg_x;

    assign nxtPC = (stall_x) ? nxtPC_m : nxtPC_x;
    assign branchTaken = (stall_x) ? branchTaken_m : branchTaken_x;

	dff iDFF0 [15:0] (.q(Addr_m), .d(Addr), .clk(clk), .rst(rst)); 
	dff iDFF1 [15:0] (.q(WriteData_m), .d(WriteData), .clk(clk), .rst(rst)); 
	dff iDFF2 [15:0] (.q(Rt_m), .d(rt), .clk(clk), .rst(rst)); 
	dff iDFF3 (.q(halt_m), .d(halt), .clk(clk), .rst(rst)); 
	dff iDFF4 (.q(MemWrite_m), .d(MemWrite), .clk(clk), .rst(rst)); 
	dff iDFF5 (.q(MemRead_m), .d(MemRead), .clk(clk), .rst(rst)); 
    dff iDFF6 (.q(MemToReg_m), .d(MemtoReg), .clk(clk), .rst(rst)); 

    dff iDFF7 [15:0] (.q(nxtPC_m), .d(nxtPC), .clk(clk), .rst(rst)); 
    dff iDFF8 (.q(branchTaken_m), .d(branchTaken), .clk(clk), .rst(rst)); 

    dff iDFF9 (.q(nop_m), .d(nop_x), .clk(clk), .rst(rst)); 
    dff iDFF10 (.q(RegWrite_m), .d(RegWrite), .clk(clk), .rst(rst)); 
    dff iDFF11[2:0] (.q(Rd_m), .d(Rd), .clk(clk), .rst(rst)); 
    
    dff iDFF12 (.q(stall_m), .d(stall_x), .clk(clk), .rst(rst)); 


endmodule
`default_nettype wire