`default_nettype none
module id_ex(   clk, rst, nop, 
                RsData_d, RtData_d, Imm_d, opcode_d, func_d, currPC_d,
                RsData_x, RtData_x, Imm_x, opcode_x, func_x, currPC_x,
                halt_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d, resultSel_d,
                halt_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x, resultSel_x);
input wire clk, rst, nop;
input wire [15:0] RsData_d, RtData_d, Imm_d, currPC_d;
output wire [15:0] RsData_x, RtData_x, Imm_x, currPC_x;
input wire [4:0] opcode_d;
output wire [4:0] opcode_x;
input wire [1:0] func_d, resultSel_d;
output wire [1:0] func_x, resultSel_x;
input wire halt_d, MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d;
output wire halt_x, MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x;

wire halt, MemRead, MemWrite, MemToReg, branch, savePC;
wire [15:0] RsData, RtData, Imm, currPC;
wire [4:0] opcode;
wire [1:0] func, resultSel;

assign RsData = nop ? RsData_x : RsData_d;
assign RtData = nop ? RtData_x : RtData_d;
assign Imm = nop ? Imm_x : Imm_d;
assign currPC = nop ? currPC_x : currPC_d;
assign opcode = nop ? opcode_x : opcode_d;

assign func = nop ? func_x : func_d;
assign resultSel = nop ? resultSel_x : resultSel_d;

assign halt = nop ? halt_x : halt_d;
assign MemRead = nop ? MemRead_x : MemRead_d;
assign MemWrite = nop ? MemWrite_x : MemWrite_d;
assign MemToReg = nop ? MemToReg_x : MemToReg_d;
assign branch   = nop ? branch_x : branch_d;
assign savePC   = nop ? savePC_x : savePC_d;  

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

endmodule
`default_nettype wire

