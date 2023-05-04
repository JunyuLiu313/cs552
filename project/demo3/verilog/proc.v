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
   output wire err;

   // wire halt;
   wire nop_d, nop_x, nop_m, nop_wb;
   wire [15:0] PC, pc_f, pc_d, pc_x, nxtPC_x;
   wire [15:0] instr_f, instr_d, instr_x, instr_m, instr_wb;
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

   // new halt logic after asserting err signals
   wire halt_wb;
   // assign halt = halt_wb | 

   wire stall_d;
   wire done;
   wire ex_err, D_err;  
   wire [2:0] Rd_d, Rd_x, Rd_m, Rd_wb;
   wire RegWrite_d, RegWrite_x, RegWrite_m, RegWrite_wb;

   // signal for forwarding
   wire [2:0] RtSel_d, RsSel_d;

   // extra signal for hazard control
   wire [1:0] resultSel_m;

   // extra signal for forwarding
   wire forward;
   wire [15:0] Rs_data_forward, Rt_data_forward;

   // additional signals for memory_system
   wire err_ifid, err_instr_mem, err_data_mem;

   /*
      Need to pass all the error signals to WB stage and raise the error flag there
   */
   wire err_idex, err_exmem;
   // err = err_memwb;

   /*
      New stall signals for calling stallmem_system in fetch and memory stage.
      If stall occured in data memory in memory stage, we should pause all the stages before memory
   */
   wire stall_f, stall_m;                       // handle stall signals from instruction memory and data memory
   wire cacheHit_f, cacheHit_m;
   wire done_f, done_m;
   
   assign stall_f = 1'b0;

   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   hazardControl h0 (//inputs
                     .Rd_d(Rd_d), .Rs_d(RsSel_d), .Rt_d(RtSel_d), 
                     .Rd_x(Rd_x), .Rd_m(Rd_m), 
                     .ResultSel_x(resultSel_x), .ResultSel_m(resultSel_m), .ResultSel_d(resultSel_d),
                     .RegWrite_x(RegWrite_x), .RegWrite_m(RegWrite_m),
                     .opcode_d(opcode_d), .opcode_x(opcode_x),
                     .Rd_data_x(writeData_x), .Rd_data_mStage(writeData_m), .Rd_data_memory(memResult_m),
                     .Rs_data_d(Rs_d), .Rt_data_d(Rt_d),
                     .memRead(MemRead_m),
                     //outputs 
                     .stall(stall_d), .forward(forward), .Rs_forward(Rs_data_forward), .Rt_forward(Rt_data_forward));

   fetch f0       (  .newPC(nxtPC_x), .INSTR(instr_f), .clk(clk), .rst(rst), .incPC(pc_f), .branchTaken(branchTaken_x), .stall(stall_d), .err(err_instr_mem),
                     // .done(done_f), .cacheHit(cacheHit_f), .stall_mem(stall_f),
                     .stall_data_mem(stall_m)
                  );
   
   if_id ifid0    (  .clk(clk), .rst(rst), .halt_d(halt_d),
                     .stall_d(stall_d),
                     .instr_f(instr_f), .pc_f(pc_f), .instr_d(instr_d), .pc_d(pc_d),
                     .branchTaken(branchTaken_x),
                     .err_instr_mem(err_instr_mem), .err_ifid(err_ifid),
                     // additional signals for stalling from instruction memory and data memory
                     .stall_f(stall_f), .stall_m(stall_m));

   decode d0      (  .clk(clk), .rst(rst), 
                     .INSTR_d(instr_d), 
                     .RegWrite_d(RegWrite_d), .Rd_d(Rd_d),
                     .RsData(Rs_d), .RtData(Rt_d), .Imm(Imm_d), .OPCODE(opcode_d), .FUNC(func_d),
                     .Rs(RsSel_d), .Rt(RtSel_d),
                     .nop(nop_d), 
                     .MemRead(MemRead_d), .MemWrite(MemWrite_d), .MemToReg(MemToReg_d), .branch(branch_d),
                     .savePC(savePC_d), .D_err(D_err), .resultSel(resultSel_d),
                     .WBdata(WBdata), .RegWrite_wb(RegWrite_wb), .Rd_wb(Rd_wb),
                     .branchTaken_x(branchTaken_x));

   id_ex idex0    (  .clk(clk), .rst(rst), .halt_d(halt_d), .halt_x(halt_x), .branchTaken(branchTaken_x),
                     .stall(stall_d),
                     .nop_d(nop_d), .nop_x(nop_x), .Rd_d(Rd_d), .Rd_x(Rd_x), 
                     .RegWrite_d(RegWrite_d), .RegWrite_x(RegWrite_x),
                     .RsData_d(Rs_data_forward), .RtData_d(Rt_data_forward), .Imm_d(Imm_d), .opcode_d(opcode_d), .func_d(func_d), .currPC_d(pc_d),
                     .RsData_x(Rs_x), .RtData_x(Rt_x), .Imm_x(Imm_x), .opcode_x(opcode_x), .func_x(func_x), .currPC_x(pc_x),
                     .MemRead_d(MemRead_d), .MemWrite_d(MemWrite_d), .MemToReg_d(MemToReg_d), .branch_d(branch_d), .savePC_d(savePC_d), .resultSel_d(resultSel_d),
                     .MemRead_x(MemRead_x), .MemWrite_x(MemWrite_x), .MemToReg_x(MemToReg_x), .branch_x(branch_x), .savePC_x(savePC_x), .resultSel_x(resultSel_x),
                     // error signals
                     .err_ifid(err_ifid), .D_err(D_err), .err_idex(err_idex),
                     .stall_m(stall_m)
                     );

   execute  iex0  (  .clk(clk), .rst(rst), .nop(nop_x),
                     .opcode(opcode_x), .Rs(Rs_x), .Rt(Rt_x), .Imm(Imm_x), .currPC(pc_x), .FUNC(func_x), 
                     .MemRead(MemRead_x), .MemWrite(MemWrite_x), .MemtoReg(MemToReg_x), 
                     .branch(branch_x), .resultSel(resultSel_x),
	                  .writeData(writeData_x), .nxtPC(nxtPC_x), .MemAddr(memAddr_x), 
                     .ex_err(ex_err), 
                     .branchTaken(branchTaken_x));

   ex_mem iexmem0 (  .clk(clk), .rst(rst), .nop_x(nop_x), .nop_m(nop_m), 
                     .Rd_x(Rd_x), .Rd_m(Rd_m), .RegWrite_x(RegWrite_x), .RegWrite_m(RegWrite_m),
                     .Addr_x(memAddr_x), .writeData_x(writeData_x), .halt_x(halt_x), .MemWrite_x(MemWrite_x), 
                     .MemRead_x(MemRead_x), .Rt_x(Rt_x), .MemToReg_x(MemToReg_x),
                     .Addr_m(memAddr_m), .WriteData_m(writeData_m), .halt_m(halt_m), .MemWrite_m(MemWrite_m), 
                     .MemRead_m(MemRead_m), .Rt_m(Rt_m), .MemToReg_m(MemToReg_m), 
                     .nxtPC_x(nxtPC_x), .nxtPC_m(PC),
                     .resultSel_x(resultSel_x), .resultSel_m(resultSel_m),

                     // error signals
                     .err_idex(err_idex), .ex_err(ex_err), .err_exmem(err_exmem),
                     .stall_m(stall_m)
                  );

   memory imem0   (  .clk(clk), .rst(rst), .halt(halt_m),
                     .Addr(memAddr_m), 
                     .WriteData(Rt_m), 
                     .MemWrite(MemWrite_m), .MemRead(MemRead_m), .ReadData(memResult_m),
                     .err(err_data_mem),
                     .done(done_m), .cacheHit(cacheHit_m), .stall_mem(stall_m)
                  );

   mem_wb imemwb0 (  .clk(clk), .rst(rst), .nop_m(nop_m), .nop_w(nop_wb), 
                     .Rd_m(Rd_m), .Rd_wb(Rd_wb), .RegWrite_m(RegWrite_m), .RegWrite_wb(RegWrite_wb),
                     .MemtoReg_m(MemToReg_m), .exResult_m(writeData_m), .memResult_m(memResult_m),
	                  .MemtoReg_w(MemToReg_wb), .exResult_w(writeData_wb), .memResult_w(memResult_wb), 
                     .halt_m(halt_m),
                     .halt_w(halt_wb),
                     .err_data_mem(err_data_mem), .err_exmem(err_exmem), .err_memwb(err),
                     .stall_m(stall_m)
                  );

   wb iwb0        (  .clk(clk), .rst(rst), 
                     .MemtoReg(MemToReg_wb), .exResult(writeData_wb), .memResult(memResult_wb), 
                     .wbResult(WBdata));

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0: