`default_nettype none
module id_ex(   clk, rst, stall,
                nop_d, nop_x, Rd_d, Rd_x,
                RegWrite_d, RegWrite_x,
                RsData_d, RtData_d, Imm_d, opcode_d, func_d, currPC_d,
                RsData_x, RtData_x, Imm_x, opcode_x, func_x, currPC_x,
                halt_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d, resultSel_d,
                halt_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x, resultSel_x,
                branchTaken_m
                );
input wire clk, rst, stall, nop_d, branchTaken_m;
output wire nop_x;

input wire [2:0] Rd_d;
output wire [2:0] Rd_x;

input wire RegWrite_d;
output wire RegWrite_x;

input wire [15:0] RsData_d, RtData_d, Imm_d, currPC_d;
output wire [15:0] RsData_x, RtData_x, Imm_x, currPC_x;

input wire [4:0] opcode_d;
output wire [4:0] opcode_x;

input wire [1:0] func_d, resultSel_d;
output wire [1:0] func_x, resultSel_x;

input wire halt_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d;
output wire halt_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x;



dff RsDX[15:0]  (.d(stall ? RsData_x : RsData_d), .q(RsData_x), .clk(clk), .rst(rst));
dff RtDX[15:0]  (.d(stall ? RtData_x : RtData_d), .q(RtData_x), .clk(clk), .rst(rst));
dff ImmDX[15:0] (.d(stall ? Imm_x : Imm_d), .q(Imm_x), .clk(clk), .rst(rst));
dff PCDX[15:0]  (.d(stall ? currPC_x : currPC_d), .q(currPC_x), .clk(clk), .rst(rst));
dff OpDX[4:0]   (.d(stall ? opcode_x : opcode_d), .q(opcode_x), .clk(clk), .rst(rst));
// dff_prec OpDX[4:0] (.d(opcode_d), .q(opcode_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));

dff funcDX[1:0]   (.d(func_d), .q(func_x), .clk(clk), .rst(rst));
dff reSelDX[1:0]  (.d(stall ? resultSel_x : resultSel_d), .q(resultSel_x), .clk(clk), .rst(rst));

dff_prec haltDX (.d(halt_d), .q(halt_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));
dff_prec MemReadDX   (.d(MemRead_d), .q(MemRead_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));
dff_prec MemWriteDX  (.d(MemWrite_d), .q(MemWrite_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));
dff_prec MemToRegDX  (.d(MemToReg_d), .q(MemToReg_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));
dff_prec branchDX    (.d(branch_d), .q(branch_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));
dff_prec savePcDX    (.d(savePC_d), .q(savePC_x), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));

dff_prec RegWriteDX  (.q(RegWrite_x), .d(RegWrite_d), .clk(clk), .rst(rst), .flush(branchTaken_m), .stall(stall));
dff RdDX [2:0]  (.q(Rd_x), .d(Rd_d), .clk(clk), .rst(rst));

dff nopDX       (.d(stall ? nop_x : nop_d), .q(nop_x), .clk(clk), .rst(rst));

endmodule
`default_nettype wire