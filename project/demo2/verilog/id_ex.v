`default_nettype none
module id_ex(   clk, rst, stall,
                nop_d, nop_x, Rd_d, Rd_x,
                RegWrite_d, RegWrite_x,
                RsData_d, RtData_d, Imm_d, opcode_d, func_d, currPC_d,
                RsData_x, RtData_x, Imm_x, opcode_x, func_x, currPC_x,
                halt_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d, resultSel_d,
                halt_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x, resultSel_x
                );
input wire clk, rst, stall, nop_d;
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



dff RsDX[15:0]  (.d(RsData_d), .q(RsData_x), .clk(clk), .rst(rst));
dff RtDX[15:0]  (.d(RtData_d), .q(RtData_x), .clk(clk), .rst(rst));
dff ImmDX[15:0] (.d(Imm_d), .q(Imm_x), .clk(clk), .rst(rst));
dff PCDX[15:0]  (.d(currPC_d), .q(currPC_x), .clk(clk), .rst(rst));
dff OpDX[4:0]   (.d(opcode_d), .q(opcode_x), .clk(clk), .rst(rst));

dff funcDX[1:0]   (.d(func_d), .q(func_x), .clk(clk), .rst(rst));
dff reSelDX[1:0](.d(resultSel_d), .q(resultSel_x), .clk(clk), .rst(rst));

dff haltDX      (.d(stall ? 1'b0 : halt_d), .q(halt_x), .clk(clk), .rst(rst));
dff MemReadDX   (.d(stall ? 1'b0 : MemRead_d), .q(MemRead_x), .clk(clk), .rst(rst));
dff MemWriteDX  (.d(stall ? 1'b0 : MemWrite_d), .q(MemWrite_x), .clk(clk), .rst(rst));
dff MemToRegDX  (.d(stall ? 1'b0 : MemToReg_d), .q(MemToReg_x), .clk(clk), .rst(rst));
dff branchDX    (.d(stall ? 1'b0 : branch_d), .q(branch_x), .clk(clk), .rst(rst));
dff savePcDX    (.d(stall ? 1'b0 : savePC_d), .q(savePC_x), .clk(clk), .rst(rst));

dff RegWriteDX  (.q(RegWrite_x), .d(stall ? 1'b0 : RegWrite_d), .clk(clk), .rst(rst));
dff RdDX [2:0]  (.q(Rd_x), .d(Rd_d), .clk(clk), .rst(rst));

dff nopDX       (.d(nop_d), .q(nop_x), .clk(clk), .rst(rst));

endmodule
`default_nettype wire