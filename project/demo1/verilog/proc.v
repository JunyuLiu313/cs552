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

   wire [15:0] PC, INSTR, currPC, WBdata, RsData, RtData, Imm;
   wire [15:0] writeData, MemAddr, ReadData;
   // control signals
   wire halt, nop, MemRead, MemWrite, MemToReg, branch, savePC, ex_err, d_err;
   wire [1:0]  resultSel, FUNC;
   wire [4:0]  OPCODE;
   
   fetch fetch0 (.PC(PC), .INSTR(INSTR), .clk(clk), .rst(rst), .currPC(currPC));
   
   
   decode decode0 (    
                  .INSTR(INSTR), .clk(clk), .rst(rst), .WBdata(WBdata),
                  //  outputs
                  .RsData(RsData), .RtData(RtData), .Imm(Imm), .OPCODE(OPCODE), .FUNC(FUNC),
                  //  control signals
                  .halt(halt), .nop(nop), .MemRead(MemRead), .MemWrite(MemWrite), .MemToReg(MemToReg),
                  .branch(branch), .savePC(savePC), .D_err(d_err), .resultSel(resultSel));
   
   
   execute execute0 
               (  .opcode(OPCODE), .Rs(RsData), .Rt(RtData), .Imm(Imm), .currPC(currPC),
                  .FUNC(FUNC), .halt(halt), .nop(nop), .MemRead(MemRead), 
                  .MemWrite(MemWrite), .MemtoReg(MemToReg), .branch(branch), .resultSel(resultSel),
	               // outputs
	               .writeData(writeData), .nxtPC(PC), .MemAddr(MemAddr), .ex_err(ex_err));
   

   memory memory0 
               (  .Addr(MemAddr), .WriteData(writeData), .halt(halt), .MemWrite(MemWrite),
                  .MemRead(MemRead), .ReadData(ReadData), .clk(clk), .rst(rst));

   
   wb writeback0 ( // inputs
               .clk(clk), .rst(rst), .MemtoReg(MemToReg), .exResult(writeData), .memResult(ReadData), 
               // outputs
               .wbResult(WBdata));   
   // None of the above lines can be modified
   
   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
