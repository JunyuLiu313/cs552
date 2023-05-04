/*
   CS/ECE 552 Spring '22
  
   Filename        : ex_mem.v
   Description     : This is the module for transiting from excuete to memory stage
*/
`default_nettype none
module ex_mem(
    clk, rst, nop_x, nop_m, Rd_x, Rd_m, RegWrite_x, RegWrite_m,
    Addr_x, writeData_x, halt_x, MemWrite_x, MemRead_x, Rt_x, MemToReg_x, nxtPC_x,
    Addr_m, WriteData_m, halt_m, MemWrite_m, MemRead_m, Rt_m, MemToReg_m, nxtPC_m,
    resultSel_x, resultSel_m,
    err_idex, ex_err, err_exmem,
    stall_m
);
    input wire clk, rst, nop_x, RegWrite_x;
    input wire [15:0] Addr_x, writeData_x, Rt_x, nxtPC_x;
    input wire halt_x, MemWrite_x, MemRead_x,MemToReg_x;
    input wire [2:0] Rd_x;

    output wire [15:0] Addr_m, WriteData_m, Rt_m, nxtPC_m;
    output wire halt_m, MemWrite_m, MemRead_m, MemToReg_m;
    output wire nop_m, RegWrite_m;
    output wire [2:0] Rd_m;

    input wire [1:0] resultSel_x;
    output wire [1:0] resultSel_m;

    // error signals
    input wire err_idex, ex_err;
    output wire err_exmem;

    input wire stall_m;

    dff iERR  (.q(err_exmem), .d(stall_m ? err_exmem : (err_idex | ex_err)), .clk(clk), .rst(rst));

	dff iDFF0 [15:0] (.q(Addr_m), .d(stall_m ? Addr_m : Addr_x), .clk(clk), .rst(rst)); 
	dff iDFF1 [15:0] (.q(WriteData_m), .d(stall_m ? WriteData_m : writeData_x), .clk(clk), .rst(rst)); 
	dff iDFF2 [15:0] (.q(Rt_m), .d(stall_m ? Rt_m : Rt_x), .clk(clk), .rst(rst)); 
	dff iDFF3 (.q(halt_m), .d(stall_m ? halt_m : halt_x), .clk(clk), .rst(rst)); 
	dff iDFF4 (.q(MemWrite_m), .d(stall_m ? MemWrite_m : MemWrite_x), .clk(clk), .rst(rst)); 
	dff iDFF5 (.q(MemRead_m), .d(stall_m ? MemRead_m : MemRead_x), .clk(clk), .rst(rst)); 
    dff iDFF6 (.q(MemToReg_m), .d(stall_m ? MemToReg_m : MemToReg_x), .clk(clk), .rst(rst)); 

    dff iDFF7 [15:0] (.q(nxtPC_m), .d(stall_m ? nxtPC_m : nxtPC_x), .clk(clk), .rst(rst)); 


    dff iDFF9 (.q(nop_m), .d(stall_m ? nop_m : nop_x), .clk(clk), .rst(rst)); 
    dff iDFF10 (.q(RegWrite_m), .d(stall_m ? RegWrite_m : RegWrite_x), .clk(clk), .rst(rst)); 
    dff iDFF11[2:0] (.q(Rd_m), .d(stall_m ? Rd_m : Rd_x), .clk(clk), .rst(rst)); 
    
    dff iDFF12[1:0] (.q(resultSel_m), .d(stall_m ? resultSel_m : resultSel_x), .clk(clk), .rst(rst)); 
    

endmodule
`default_nettype wire