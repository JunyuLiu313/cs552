`default_nettype none
module id_ex(   clk, rst, stall, nop_d, nop_x, Rd_d, Rd_x, RegWrite_d, RegWrite_x,
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


wire halt, MemRead, MemWrite, MemToReg, branch, savePC, RegWrite;
wire [15:0] RsData, RtData, Imm, currPC;
wire [4:0] opcode;
wire [1:0] func, resultSel;
wire [2:0] Rd;

assign RegWrite = (stall) ? RegWrite_x : RegWrite_d;
assign Rd = (stall) ? Rd_x : Rd_d;
assign RsData = (stall | nop_d) ? RsData_x : RsData_d;
assign RtData = (stall | nop_d) ? RtData_x : RtData_d;
assign Imm = (stall | nop_d) ? Imm_x : Imm_d;
assign currPC = (stall) ? currPC_x : currPC_d;
assign opcode = (stall | nop_d) ? opcode_x : opcode_d;

assign func = (stall | nop_d) ? func_x : func_d;
assign resultSel = (stall | nop_d) ? resultSel_x : resultSel_d;

assign halt = stall ? halt_x : halt_d;
assign MemRead = (stall) ? MemRead_x : MemRead_d;
assign MemWrite = (stall) ? MemWrite_x : MemWrite_d;
assign MemToReg = (stall | nop_d) ? MemToReg_x : MemToReg_d;
assign branch   = (stall | nop_d) ? branch_x : branch_d;
assign savePC   = (stall | nop_d) ? savePC_x : savePC_d;  


dff RsDX[15:0]  (.d(RsData), .q(RsData_x), .clk(clk), .rst(rst));
dff RtDX[15:0]  (.d(RtData), .q(RtData_x), .clk(clk), .rst(rst));
dff ImmDX[15:0] (.d(Imm), .q(Imm_x), .clk(clk), .rst(rst));
dff PCDX[15:0]  (.d(currPC), .q(currPC_x), .clk(clk), .rst(rst));
dff OpDX[4:0]   (.d(opcode), .q(opcode_x), .clk(clk), .rst(rst));

dff funcDX[1:0]   (.d(func), .q(func_x), .clk(clk), .rst(rst));
dff reSelDX[1:0](.d(resultSel), .q(resultSel_x), .clk(clk), .rst(rst));

dff haltDX      (.d(halt), .q(halt_x), .clk(clk), .rst(rst));
dff MemReadDX   (.d(MemRead), .q(MemRead_x), .clk(clk), .rst(rst));
dff MemWriteDX  (.d(MemWrite), .q(MemWrite_x), .clk(clk), .rst(rst));
dff MemToRegDX  (.d(MemToReg), .q(MemToReg_x), .clk(clk), .rst(rst));
dff branchDX    (.d(branch), .q(branch_x), .clk(clk), .rst(rst));
dff savePcDX    (.d(savePC), .q(savePC_x), .clk(clk), .rst(rst));

dff RegWriteDX  (.q(RegWrite_x), .d(RegWrite), .clk(clk), .rst(rst));
dff RdDX [2:0]  (.q(Rd_x), .d(Rd), .clk(clk), .rst(rst));

dff nopDX       (.d(nop_d), .q(nop_x), .clk(clk), .rst(rst));

endmodule
`default_nettype wire