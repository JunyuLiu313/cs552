/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;
   output reg err;

   wire halt;
   wire nop_d, nop_x, nop_m, nop_wb;
   wire [15:0] PC, pc_f, pc_d, pc_x, nxtPC_x;
   wire [15:0] instr_f, instr_d;
   wire [15:0] WBdata;
   wire [15:0] Rs_x, Rt_x, Imm_x, Rs_d, Rt_d, Imm_d, Rt_m;
   wire [4:0] opcode_d, opcode_x;
   wire [1:0] func_d, func_x, resultSel_d, resultSel_x;
   wire halt_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d;
   wire halt_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x;

   // siganl for branch taken used in fetch
   wire branchTaken_x, branchTaken_m;

   wire halt_m, MemWrite_m, MemRead_m, MemToReg_m;
   wire MemToReg_wb;
   wire [15:0] writeData_x, writeData_m, writeData_wb;
   wire [15:0] memAddr_x, memAddr_m;
   wire [15:0] memResult_m, memResult_wb;
   wire halt_wb;
   wire stall_f, stall_d;
   wire done;
   wire ex_err, D_err;  
   wire [2:0] Rd_d, Rd_x, Rd_m, Rd_wb;
   wire RegWrite_d, RegWrite_x, RegWrite_m, RegWrite_wb;

   // signal for forwarding
   wire [2:0] RtSel_d, RsSel_d;

   // extra signal for hazard control
   wire [1:0] resultSel_m;

   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   hazardControl h0 (//inputs
                     .Rd_d(Rd_d), .Rs_d(RsSel_d), .Rt_d(RtSel_d), 
                     .Rd_x(Rd_x), .Rd_m(Rd_m), 
                     .ResultSel_x(resultSel_x), .ResultSel_m(resultSel_m), .ResultSel_d(resultSel_d),
                     .RegWrite_x(RegWrite_x), .RegWrite_m(RegWrite_m),
                     .opcode(opcode_d),
                     //outputs 
                     .stall(stall_f));
   fetch f0       (  .PC(PC), .INSTR(instr_f), .clk(clk), .rst(rst), .currPC(pc_f), .branchTaken(branchTaken_m), .stall(stall_f));
   
   if_id ifid0    (  .clk(clk), .rst(rst), 
                     .stall_f(stall_f), .stall_d(stall_d),.halt(halt),
                     .instr_f(instr_f), .pc_f(pc_f), .instr_d(instr_d), .pc_d(pc_d),
                     .branchTaken_m(branchTaken_m));

   decode d0      (  .clk(clk), .rst(rst), 
                     .INSTR(instr_d), 
                     .RegWrite_d(RegWrite_d), .Rd_d(Rd_d),
                     .RsData(Rs_d), .RtData(Rt_d), .Imm(Imm_d), .OPCODE(opcode_d), .FUNC(func_d),
                     .stall(stall_d),
                     // signals for forwarding
                     .Rs(RsSel_d), .Rt(RtSel_d),
                     .halt(halt_d), .nop(nop_d), 
                     .MemRead(MemRead_d), .MemWrite(MemWrite_d), .MemToReg(MemToReg_d), .branch(branch_d),
                     .savePC(savePC_d), .D_err(D_err), .resultSel(resultSel_d),
                     .WBdata(WBdata), .RegWrite_wb(RegWrite_wb), .Rd_wb(Rd_wb),
                     .branchTaken_x(branchTaken_m));

   id_ex idex0    (  .clk(clk), .rst(rst), .stall(stall_f),
                     .branchTaken_m(branchTaken_m),
                     .nop_d(nop_d), .nop_x(nop_x), .Rd_d(Rd_d), .Rd_x(Rd_x), 
                     .RegWrite_d(RegWrite_d), .RegWrite_x(RegWrite_x),
                     .RsData_d(Rs_d), .RtData_d(Rt_d), .Imm_d(Imm_d), .opcode_d(opcode_d), .func_d(func_d), .currPC_d(pc_d),
                     .RsData_x(Rs_x), .RtData_x(Rt_x), .Imm_x(Imm_x), .opcode_x(opcode_x), .func_x(func_x), .currPC_x(pc_x),
                     .halt_d(halt_d), .MemRead_d(MemRead_d), .MemWrite_d(MemWrite_d), .MemToReg_d(MemToReg_d), .branch_d(branch_d), .savePC_d(savePC_d), .resultSel_d(resultSel_d),
                     .halt_x(halt_x), .MemRead_x(MemRead_x), .MemWrite_x(MemWrite_x), .MemToReg_x(MemToReg_x), .branch_x(branch_x), .savePC_x(savePC_x), .resultSel_x(resultSel_x));

   execute  iex0  (  .clk(clk), .rst(rst), .halt(halt_x), .nop(nop_x),
                     .opcode(opcode_x), .Rs(Rs_x), .Rt(Rt_x), .Imm(Imm_x), .currPC(pc_x), .FUNC(func_x), 
                     .MemRead(MemRead_x), .MemWrite(MemWrite_x), .MemtoReg(MemToReg_x), 
                     .branch(branch_x), .resultSel(resultSel_x),
	                  .writeData(writeData_x), .nxtPC(nxtPC_x), .MemAddr(memAddr_x), 
                     .ex_err(ex_err), 
                     .branchTaken(branchTaken_x));

   ex_mem iexmem0 (  .clk(clk), .rst(rst), .nop_x(nop_x), .nop_m(nop_m),
                     .Rd_x(Rd_x), .Rd_m(Rd_m), .RegWrite_x(RegWrite_x), .RegWrite_m(RegWrite_m),
                     .Addr_x(memAddr_x), .writeData_x(writeData_x), .halt_x(halt_x), .MemWrite_x(MemWrite_x), 
                     .MemRead_x(MemRead_x), .Rt_x(Rt_x), .MemToReg_x(MemToReg_x), .branchTaken_x(branchTaken_x),
                     .Addr_m(memAddr_m), .WriteData_m(writeData_m), .halt_m(halt_m), .MemWrite_m(MemWrite_m), 
                     .MemRead_m(MemRead_m), .Rt_m(Rt_m), .MemToReg_m(MemToReg_m), .branchTaken_m(branchTaken_m),
                     .nxtPC_x(nxtPC_x), .nxtPC_m(PC),
                     .resultSel_x(resultSel_x), .resultSel_m(resultSel_m));

   memory imem0   (  .clk(clk), .rst(rst), .halt(halt_m),
                     .Addr(memAddr_m), 
                     .WriteData(Rt_m), 
                     .MemWrite(MemWrite_m), .MemRead(MemRead_m), .ReadData(memResult_m));

   mem_wb imemwb0 (  .clk(clk), .rst(rst), .nop_m(nop_m), .nop_w(nop_wb), 
                     .Rd_m(Rd_m), .Rd_wb(Rd_wb), .RegWrite_m(RegWrite_m), .RegWrite_wb(RegWrite_wb),
                     .MemtoReg_m(MemToReg_m), .exResult_m(writeData_m), .memResult_m(memResult_m),
	                  .MemtoReg_w(MemToReg_wb), .exResult_w(writeData_wb), .memResult_w(memResult_wb), 
                     .halt_m(halt_m),
                     .halt_w(halt_wb));

   wb iwb0        (  .clk(clk), .rst(rst), 
                     .MemtoReg(MemToReg_wb), .exResult(writeData_wb), .memResult(memResult_wb), 
                     .wbResult(WBdata));

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0: