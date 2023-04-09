/*
   CS/ECE 552 Spring '22
  
   Filename        : ex_mem.v
   Description     : This is the module for transiting from excuete to memory stage
*/
`default_nettype none
module ex_mem(
    clk, rst, nop_x, nop_m, Rd_x, Rd_m, RegWrite_x, RegWrite_m,
    Addr_x, writeData_x, halt_x, MemWrite_x, MemRead_x, Rt_x, MemToReg_x, nxtPC_x, branchTaken_x,
    Addr_m, WriteData_m, halt_m, MemWrite_m, MemRead_m, Rt_m, MemToReg_m, nxtPC_m, branchTaken_m,
    resultSel_x, resultSel_m
);
    input wire clk, rst, nop_x, RegWrite_x;
    input wire [15:0] Addr_x, writeData_x, Rt_x, nxtPC_x;
    input wire halt_x, MemWrite_x, MemRead_x,MemToReg_x, branchTaken_x;
    input wire [2:0] Rd_x;

    output wire [15:0] Addr_m, WriteData_m, Rt_m, nxtPC_m;
    output wire halt_m, MemWrite_m, MemRead_m, MemToReg_m, branchTaken_m;
    output wire nop_m, RegWrite_m;
    output wire [2:0] Rd_m;

    input wire [1:0] resultSel_x;
    output wire [1:0] resultSel_m;

	dff iDFF0 [15:0] (.q(Addr_m), .d(Addr_x), .clk(clk), .rst(rst)); 
	dff iDFF1 [15:0] (.q(WriteData_m), .d(writeData_x), .clk(clk), .rst(rst)); 
	dff iDFF2 [15:0] (.q(Rt_m), .d(Rt_x), .clk(clk), .rst(rst)); 
	dff iDFF3 (.q(halt_m), .d(halt_x), .clk(clk), .rst(rst)); 
	dff iDFF4 (.q(MemWrite_m), .d(MemWrite_x), .clk(clk), .rst(rst)); 
	dff iDFF5 (.q(MemRead_m), .d(MemRead_x), .clk(clk), .rst(rst)); 
    dff iDFF6 (.q(MemToReg_m), .d(MemToReg_x), .clk(clk), .rst(rst)); 

    dff iDFF7 [15:0] (.q(nxtPC_m), .d(nxtPC_x), .clk(clk), .rst(rst)); 
    dff iDFF8 (.q(branchTaken_m), .d(branchTaken_x), .clk(clk), .rst(rst)); 

    dff iDFF9 (.q(nop_m), .d(nop_x), .clk(clk), .rst(rst)); 
    dff iDFF10 (.q(RegWrite_m), .d(RegWrite_x), .clk(clk), .rst(rst)); 
    dff iDFF11[2:0] (.q(Rd_m), .d(Rd_x), .clk(clk), .rst(rst)); 
    
    dff iDFF12[1:0] (.q(resultSel_m), .d(resultSel_x), .clk(clk), .rst(rst)); 
    

endmodule
`default_nettype wire