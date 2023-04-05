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

   wire [15:0] PC, pc_f, pc_d, pc_x, nxtPC_x;
   wire [15:0] instr_f, instr_d;
   wire [15:0] WBdata;
   wire [15:0] Rs_x, Rt_x, Imm_x, Rs_d, Rt_d, Imm_d, Rt_m;
   wire [4:0] opcode_d, opcode_x;
   wire [1:0] func_d, func_x, resultSel_d, resultSel_x;
   wire halt_d, nop_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d;
   wire halt_x, nop_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x;
   wire halt_m, nop_m, MemWrite_m, MemRead_m, MemToReg_m;
   wire nop_wb, MemToReg_wb;
   wire [15:0] writeData_x, writeData_m, writeData_wb;
   wire [15:0] memAddr_x, memAddr_m;
   wire [15:0] memResult_m, memResult_wb;
   wire ex_err, D_err;   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   fetch f0       (  .PC(PC), .INSTR(instr_f), .clk(clk), .rst(rst), .currPC(pc_f));
   
   if_id ifid0    (  .instr_f(instr_f), .pc_f(pc_f), .clk(clk), .rst(rst), .instr_d(instr_d), .pc_d(pc_d), .nop(nop_d));

   decode d0      (  .INSTR(instr_d), .clk(clk), .rst(rst), .WBdata(WBdata), 
                     .RsData(Rs_d), .RtData(Rt_d), .Imm(Imm_d), .OPCODE(opcode_d), .FUNC(func_d),
                     .halt(halt_d), .nop(nop_d), .MemRead(MemRead_d), .MemWrite(MemWrite_d), .MemToReg(MemToReg_d), .branch(branch_d),
                     .savePC(savePC_d), .D_err(D_err), .resultSel(resultSel_d));
   id_ex idex0    (  .clk(clk), .rst(rst), .nop(nop_d),
                     .RsData_d(Rs_d), .RtData_d(Rt_d), .Imm_d(Imm_d), .opcode_d(opcode_d), .func_d(func_d), .currPC_d(pc_d),
                     .RsData_x(Rs_x), .RtData_x(Rt_x), .Imm_x(Imm_x), .opcode_x(opcode_x), .func_x(func_x), .currPC_x(pc_x),
                     .halt_d(halt_d), .MemRead_d(MemRead_d), .MemWrite_d(MemWrite_d), .MemToReg_d(MemToReg_d), .branch_d(branch_d), .savePC_d(savePC_d), .resultSel_d(resultSel_d),
                     .halt_x(halt_x), .MemRead_x(MemRead_x), .MemWrite_x(MemWrite_x), .MemToReg_x(MemToReg_x), .branch_x(branch_x), .savePC_x(savePC_x), .resultSel_x(resultSel_x));

   execute  iex0  (  .clk(clk), .rst(rst), 
                     .opcode(opcode_x), .Rs(Rs_x), .Rt(Rt_x), .Imm(Imm_x), .currPC(pc_x), .FUNC(func_x), 
                     .halt(halt_x), .nop(nop_x), 
                     .MemRead(MemRead_x), .MemWrite(MemWrite_x), .MemtoReg(MemToReg_x), .branch(branch_x), .resultSel(resultSel_d),
	                  .writeData(writeData_x), .nxtPC(PC), .MemAddr(memAddr_x), .ex_err(ex_err));

   ex_mem iexmem0 (  .clk(clk), .rst(rst), .nop(nop_m), 
                     .Addr_x(memAddr_x), .writeData_x(writeData_x), .halt_x(halt_x), .MemWrite_x(MemWrite_x), .MemRead_x(MemRead_x), .Rt_x(Rt_x), .MemToReg_x(MemToReg_x),
                     .Addr_m(memAddr_m), .WriteData_m(writeData_m), .halt_m(halt_m), .MemWrite_m(MemWrite_m), .MemRead_m(MemRead_m), .Rt_m(Rt_m));

   memory imem0   (  .clk(clk), .rst(rst), .halt(halt_m),
                     .Addr(memAddr_m), .WriteData(Rt_m), .MemWrite(MemWrite_m), .MemRead(MemRead_m), .ReadData(memResult_m));

   mem_wb imemwb0 (  .clk(clk), .rst(rst), .nop(nop_m), 
                     .MemtoReg_m(MemToReg_m), .exResult_m(writeData_m), .memResult_m(memResult_m),
	                  .MemtoReg_w(MemToReg_wb), .exResult_w(writeData_wb), .memResult_w(memResult_wb));

   wb iwb0     (  .clk(clk), .rst(rst), 
                     .MemtoReg(MemToReg_wb), .exResult(writeData_wb), .memResult(memResult_wb), 
                     .wbResult(WBdata));

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0: