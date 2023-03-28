/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode(  //  inputs
                INSTR, PC, clk, rst, WBdata,
                //  outputs
                RsData, RtData, Imm, currPC, OPCODE, FUNC,
                //  control signals
                halt, nop, MemRead, MemWrite, MemToReg, branch,
                err);

input wire [15:0] INSTR, PC, WBdata;
input wire clk, rst;

output wire [15:0] RsData, RtData, Imm, currPC;
output wire [4:0] OPCODE;
output wire [1:0] FUNC;
output wire err;
//  Control signals
//  RegWrite = RF.writeEn Rd = writeRegSel
output wire halt, nop, MemRead, MemWrite, MemToReg, branch;
wire ZeroExt1, ZeroExt2, savePC, RTI, SIIC, RegWrite;
wire [2:0] Rd, Rt, Rs;

dff PC_D(// inputs
            .d(PC), .clk(clk), .rst(rst),
        //  outputs
            .q(currPC));

control CS( //  input
            .INSTR(INSTR),
            //  outputs
            .halt(halt), .nop(nop), .MemRead(MemRead), .RegWrite(RegWrite), 
            .MemWrite(MemWrite), .MemToReg(MemToReg), .branch(branch),  
            .savePC(savePC), .RTI(RTI), .SIIC(SIIC), .OPCODE(OPCODE), 
            .FUNC(FUNC), .Rs(Rs), .Rd(Rd), .Rt(Rt), .ZeroExt1(ZeroExt1), .ZeroExt2(ZeroExt2));

rf_bypass RF(// inputs
            .clk(clk), .rst(rst), .read1RegSel(Rs), .read2RegSel(Rt),
             .writeRegSel(Rd), .writeInData(WBdata), .writeEn(RegWrite),
            //  outputs
            .read1OutData(RsData), .read2OutData(RtData), .err(err));

wire [15:0] Imm_i, i1, i2;
	assign i1 	 =  ZeroExt1 ? {{11{1'b0}}, INSTR[4:0]} : {{11{INSTR[4]}}, INSTR[4:0]}; 
	assign i2 	 =  ZeroExt2 ? {{8{1'b0}}, INSTR[7:0]}	: {{8{INSTR[7]}},INSTR[7:0]};
	assign Imm_i =  ((INSTR[15]&~INSTR[14])|(~INSTR[15]&INSTR[14]&~INSTR[13])|
                    (~INSTR[15]&~INSTR[14]&INSTR[13]&~INSTR[12]&INSTR[11])|
                    (~INSTR[15]&~INSTR[14]&INSTR[13]&INSTR[12]&INSTR[11])) ? i1 : i2;
	assign Imm 	 =  (~INSTR[15]&~INSTR[14]&INSTR[13]) ? {{5{INSTR[10]}}, INSTR[10:0]} : Imm_i;

endmodule