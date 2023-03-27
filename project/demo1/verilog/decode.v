
/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (INSTR, Opcode, imm, RsData, RtData, AluOP, clk, rst, addr, DCaddr, memWrite, memRead, savePC);

	// TODO: Your code here
	input wire [15:0] INSTR, addr;
	input wire clk, rst;
   
	output wire [15:0]	RsData, RtData, DCaddr;
	output wire [4:0] 	Opcode;
	output wire [16:0] 	imm;
	output wire [1:0]	AluOP;

	output wire memWrite, memRead;		// control signals for MEM stage
	output wire savePC;			// true if R7 <- PC + 2

	// pass the pc address
	assign DCaddr = addr;


	//	control singals
	wire [2:0] Rd, Rt, Rs;
	wire z_ext_1, z_ext_2, writeRegSel, writeEn, halt, nop, Rd_i, exc;
	wire [15:0] imm_i, i_1, i_2, writeInData;

	assign halt = !(INSTR[15]|INSTR[14]|INSTR[13]|INSTR[12]|INSTR[11]);
	assign nop = (!(INSTR[15]|INSTR[14]|INSTR[13]|INSTR[12]))&INSTR[11];
	assign Rd_i = (INSTR[15]&~INSTR[14]&~INSTR[13]&INSTR[12]&INSTR[11]) ? Rs : Rd;
	assign writeRegSel = ~INSTR[15] & ~INSTR[14] & INSTR[13] & INSTR[12] ? 3'b111 :	Rd_i; 
	
	// EX control signals 
	assign z_ext_1 = ~INSTR[15]&INSTR[14]&~INSTR[13]&INSTR[12];
	assign z_ext_2 =  INSTR[15]&~INSTR[14]&~INSTR[13]&INSTR[12];

	assign Opcode 	= INSTR[15:11];
	assign Rs 		= INSTR[10:8];
	assign Rt 		= INSTR[7:5];
	assign Rd 		= (INSTR[15] & INSTR[14]) ? INSTR[4:2] : INSTR[7:5];
	assign AluOP 	= INSTR[1:0];

	assign i_1 		= z_ext_1 ? {{11{1'b0}}, INSTR[4:0]} : {{11{INSTR[4]}}, INSTR[4:0]}; 
	assign i_2 		= z_ext_2 ? {{8{1'b0}}, INSTR[7:0]}	: {{8{INSTR[7]}},INSTR[7:0]};
	assign imm_i 	= ((INSTR[15]&~INSTR[14])|(~INSTR[15]&INSTR[14]&~INSTR[13])|(~INSTR[15]&~INSTR[14]&INSTR[13]&~INSTR[12]&INSTR[11])|(~INSTR[15]&~INSTR[14]&INSTR[13]&INSTR[12]&INSTR[11])) ? i_1 : i_2;
	assign imm 		= (~INSTR[15]&~INSTR[14]&INSTR[13]) ? {{5{INSTR[10]}}, INSTR[10:0]} : imm_i;

	// control signals for Memory stage
	assign memWrite = (INSTR[15]&~INSTR[14]&~INSTR[13]&~INSTR[12]&~INSTR[11]) | (INSTR[15]&~INSTR[14]&~INSTR[13]&INSTR[12]&INSTR[11]);
	assign memRead = (INSTR[15]&~INSTR[14]&~INSTR[13]&~INSTR[12]&INSTR[11]);

	// WB control signals
	assign savePC = (~INSTR[15]&~INSTR[14]&INSTR[13]&INSTR[12]);

	rf_bypass RF (
                  .read1OutData(RsData), .read2OutData(RtData), .err(exc),
                  .clk(clk), .rst(rst), .read1RegSel(Rs), .read2RegSel(Rt), .writeRegSel(writeRegSel), .writeInData(writeInData), .writeEn(writeEn)
                  );	
	
	
endmodule
`default_nettype wire
