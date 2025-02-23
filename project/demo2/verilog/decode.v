/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode(  //  inputs
                INSTR_d, clk, rst, WBdata, Rd_wb, RegWrite_wb, branchTaken_x,
                //  outputs
                RsData, RtData, Imm, OPCODE, FUNC, Rd_d, Rt, Rs,
                //  control signals
                nop, MemRead, MemWrite, MemToReg, branch, savePC,
                D_err, resultSel, RegWrite_d);

input wire [15:0] INSTR_d, WBdata;
input wire clk, rst, RegWrite_wb;
input wire [2:0] Rd_wb;

// flash signals
input wire branchTaken_x;

output wire [15:0] RsData, RtData, Imm;
output wire [4:0] OPCODE;
output wire [1:0] FUNC, resultSel;
output wire D_err, RegWrite_d;
output wire [2:0] Rd_d;
output wire [2:0] Rt, Rs;

//  Control signals
output wire nop, MemRead, MemWrite, MemToReg, branch, savePC;
wire ZeroExt1, ZeroExt2, RTI, SIIC, jump, JR;

wire r, if1, if2, j;
wire [1:0] resultSel_i1, resultSel_i2;

wire [15:0] instr;
assign instr = (branchTaken_x) ? 16'h0800 : INSTR_d;

wire haltTemp, halt;
assign halt = haltTemp & ~rst;

control CS( //  input
            .INSTR(instr),
            //  outputs
            .halt(haltTemp), .nop(nop), .MemRead(MemRead), .RegWrite(RegWrite_d), 
            .MemWrite(MemWrite), .MemToReg(MemToReg), .jump(jump), .JR(JR), .if1(if1), .if2(if2), .j(j), .r(r),
            .savePC(savePC), .RTI(RTI), .SIIC(SIIC), .OPCODE(OPCODE),
            .FUNC(FUNC), .Rs(Rs), .Rd(Rd_d), .Rt(Rt), .ZeroExt1(ZeroExt1), .ZeroExt2(ZeroExt2), .branch(branch));

rf_bypass   regFile0(//  inputs
            .clk(clk), .rst(rst), .read1RegSel(Rs), .read2RegSel(Rt),
             .writeRegSel(Rd_wb), .writeInData(WBdata), .writeEn(RegWrite_wb),
            //  outputs
            .read1OutData(RsData), .read2OutData(RtData), .err(D_err));

assign resultSel_i1  = r | if1 ? 2'b00 : 2'b10;
assign resultSel_i2  = r | if2 ? 2'b00 : 2'b01;
assign resultSel = resultSel_i1 | resultSel_i2;

wire [15:0] Imm_i, i1, i2;
assign i1 	 =  ZeroExt1 ? {{11{1'b0}}, instr[4:0]} : {{11{instr[4]}}, instr[4:0]}; 
assign i2 	 =  ZeroExt2 ? {{8{1'b0}}, instr[7:0]}	: {{8{instr[7]}},instr[7:0]};
assign Imm_i =  ((~instr[15]&instr[14]&~instr[13]) | (instr[15]&~instr[14]&instr[13]) 
               | (instr[15]&~instr[14]&~instr[13]&~instr[12]) 
               | (instr[15]&~instr[14]&~instr[13]&instr[12]&instr[11])) ? i1 : i2;
assign Imm 	 =  (~instr[15]&~instr[14]&instr[13]&~instr[11]) ? {{5{instr[10]}}, instr[10:0]} : Imm_i;

endmodule
`default_nettype wire