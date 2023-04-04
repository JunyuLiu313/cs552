/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode(  //  inputs
                INSTR, clk, rst, WBdata,
                //  outputs
                RsData, RtData, Imm, OPCODE, FUNC,
                //  control signals
                halt, nop, MemRead, MemWrite, MemToReg, branch, savePC,
                D_err, resultSel);

input wire [15:0] INSTR, WBdata;
input wire clk, rst;

output wire [15:0] RsData, RtData, Imm;
output wire [4:0] OPCODE;
output wire [1:0] FUNC, resultSel;
output wire D_err;
//  Control signals
output wire halt, nop, MemRead, MemWrite, MemToReg, branch, savePC;
wire ZeroExt1, ZeroExt2, RTI, SIIC, RegWrite, jump, JR;
wire [2:0] Rd, Rt, Rs;
wire r, if1, if2, j;
wire [1:0] resultSel_i1, resultSel_i2;
// wire [15:0] WBdataReg;
// dff wbReg[15:0] (.q(WBdataReg), .d(WBdata), .clk(clk), .rst(rst));
// wire [15:0] RsDataReg;
// dff WBREG [15:0] (.q(RsData), .d(RsDataReg), .clk(clk), .rst(rst));

control CS( //  input
            .INSTR(INSTR),
            //  outputs
            .halt(halt), .nop(nop), .MemRead(MemRead), .RegWrite(RegWrite), 
            .MemWrite(MemWrite), .MemToReg(MemToReg), .jump(jump), .JR(JR), .if1(if1), .if2(if2), .j(j), .r(r),
            .savePC(savePC), .RTI(RTI), .SIIC(SIIC), .OPCODE(OPCODE),
            .FUNC(FUNC), .Rs(Rs), .Rd(Rd), .Rt(Rt), .ZeroExt1(ZeroExt1), .ZeroExt2(ZeroExt2), .branch(branch));

rf       regFile0(//  inputs
            .clk(clk), .rst(rst), .read1RegSel(Rs), .read2RegSel(Rt),
             .writeRegSel(Rd), .writeInData(WBdata), .writeEn(RegWrite),
            //  outputs
            .read1OutData(RsData), .read2OutData(RtData), .err(D_err));

assign resultSel_i1  = r | if1 ? 2'b00 : 2'b10;
assign resultSel_i2  = r | if2 ? 2'b00 : 2'b01;
assign resultSel = resultSel_i1 | resultSel_i2;

wire [15:0] Imm_i, i1, i2;
assign i1 	 =  ZeroExt1 ? {{11{1'b0}}, INSTR[4:0]} : {{11{INSTR[4]}}, INSTR[4:0]}; 
assign i2 	 =  ZeroExt2 ? {{8{1'b0}}, INSTR[7:0]}	: {{8{INSTR[7]}},INSTR[7:0]};
assign Imm_i =  ((~INSTR[15]&INSTR[14]&~INSTR[13]) | (INSTR[15]&~INSTR[14]&INSTR[13]) 
               | (INSTR[15]&~INSTR[14]&~INSTR[13]&~INSTR[12]) 
               | (INSTR[15]&~INSTR[14]&~INSTR[13]&INSTR[12]&INSTR[11])) ? i1 : i2;
assign Imm 	 =  (~INSTR[15]&~INSTR[14]&INSTR[13]&~INSTR[11]) ? {{5{INSTR[10]}}, INSTR[10:0]} : Imm_i;

endmodule