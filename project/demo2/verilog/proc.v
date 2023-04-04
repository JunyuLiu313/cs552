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

   wire [15:0] PC, pc_f, pc_d, pc_x;
   wire [15:0] instr_f, instr_d;
   wire [15:0] WBdata;
   wire [15:0] Rs_x, Rt_x, Imm_x, Rs_d, Rt_d, Imm_d, Rt_m;
   wire [4:0] opcode_d, opcode_x;
   wire [1:0] func_d, func_x, resultSel_d, resultSel_x;
   wire halt_d, nop_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d;
   wire halt_x, nop_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x;
   wire halt_m, nop_m, MemWrite_m, MemRead_m, MemToReg_m, MemToReg_wb;
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
                     .RsData_d(Rs_d), .RtData_d(Rt_d), .Imm_d(Imm_d), .opcode_d(opcode_d), .func_d(func_d),
                     .RsData_x(Rs_x), .RtData_x(Rt_x), .Imm_x(Imm_x), .opcode_x(opcode_x), .func_x(func_x),
                     .halt_d(halt_d), .MemRead_d(MemRead_d), .MemWrite_d(MemWrite_d), .MemToReg_d(MemToReg_d), .branch_d(branch_d), .savePC_d(savePC_d), .resultSel_d(resultSel_d),
                     .halt_x(halt_x), .MemRead_x(MemRead_x), .MemWrite_x(MemWrite_x), .MemToReg_x(MemToReg_x), .branch_x(branch_x), .savePC_x(savePC_x), .resultSel_x(resultSel_x));
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
