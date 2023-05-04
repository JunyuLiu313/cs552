`default_nettype none
module id_ex(   clk, rst,
                nop_d, nop_x, Rd_d, Rd_x,
                RegWrite_d, RegWrite_x,
                RsData_d, RtData_d, Imm_d, opcode_d, func_d, currPC_d,
                RsData_x, RtData_x, Imm_x, opcode_x, func_x, currPC_x,
                MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d, resultSel_d,
                MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x, resultSel_x,
                branchTaken,
                halt_d, halt_x, stall,

                // error signals
                err_ifid, D_err, err_idex,
                stall_m
            );
input wire clk, rst, nop_d, halt_d, branchTaken, stall;
output wire nop_x, halt_x;

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

input wire MemRead_d, MemWrite_d, MemToReg_d, branch_d, savePC_d;
output wire MemRead_x, MemWrite_x, MemToReg_x, branch_x, savePC_x;

// error signals
input wire err_ifid, D_err;
output wire err_idex;

input wire stall_m;

dff ERR         (.d((stall | stall_m) ? err_idex : (err_ifid | D_err)), .q(err_idex), .clk(clk), .rst(rst));

wire halt = (branchTaken) ? 1'b0 : halt_d;
dff HaltDX (.d((stall | stall_m) ? halt_x : halt), .q(halt_x), .clk(clk), .rst(rst));

dff RsDX[15:0]  (.d((stall | stall_m) ? RsData_x : RsData_d), .q(RsData_x), .clk(clk), .rst(rst));
dff RtDX[15:0]  (.d((stall | stall_m) ? RtData_x : RtData_d), .q(RtData_x), .clk(clk), .rst(rst));
dff ImmDX[15:0] (.d((stall | stall_m) ? Imm_x : Imm_d), .q(Imm_x), .clk(clk), .rst(rst));
dff PCDX[15:0]  (.d((stall | stall_m) ? currPC_x : currPC_d), .q(currPC_x), .clk(clk), .rst(rst));
dff OpDX[4:0]   (.d((stall | stall_m) ? opcode_x : opcode_d), .q(opcode_x), .clk(clk), .rst(rst));

dff funcDX[1:0]   (.d((stall | stall_m) ? func_x : func_d), .q(func_x), .clk(clk), .rst(rst));
dff reSelDX[1:0]  (.d((stall | stall_m) ? resultSel_x : resultSel_d), .q(resultSel_x), .clk(clk), .rst(rst));

dff MemReadDX   (.d((stall | stall_m) ? MemRead_x : MemRead_d), .q(MemRead_x), .clk(clk), .rst(rst));
dff MemWriteDX  (.d((stall | stall_m) ? MemWrite_x : MemWrite_d), .q(MemWrite_x), .clk(clk), .rst(rst | halt_x));
dff MemToRegDX  (.d((stall | stall_m) ? MemToReg_x : MemToReg_d), .q(MemToReg_x), .clk(clk), .rst(rst));
dff branchDX    (.d((stall | stall_m) ? branch_x : branch_d), .q(branch_x), .clk(clk), .rst(rst));
dff savePcDX    (.d((stall | stall_m) ? 1'b0 : savePC_d), .q(savePC_x), .clk(clk), .rst(rst));

dff RegWriteDX  (.q(RegWrite_x), .d((stall | stall_m) ? RegWrite_x: RegWrite_d), .clk(clk), .rst(rst));
dff RdDX [2:0]  (.q(Rd_x), .d((stall | stall_m) ? Rd_x : Rd_d), .clk(clk), .rst(rst));

dff nopDX       (.d((stall | stall_m) ? 1'b1 : nop_d), .q(nop_x), .clk(clk), .rst(rst));

endmodule
`default_nettype wire