`default_nettype none
module if_id(   instr_f, pc_f, clk, rst, instr_d, pc_d, halt_d, 
                err_instr_mem, err_ifid,
                stall_d, branchTaken, 
                stall_f, stall_m);
input wire [15:0] instr_f, pc_f;
input wire clk, rst, branchTaken;
input wire err_instr_mem;
output wire [15:0] instr_d, pc_d;
output wire halt_d, err_ifid;
input wire stall_d;

input wire stall_f, stall_m;

wire [15:0] instr_stall, instr_branchTaken;
wire halt_f;

// if the instruction in d is halt, we shouldn't do anything after halt
assign instr_stall = // (instr_d[15:11] == 5'b0) ? 16'h0800 : 
                    (stall_d | stall_m) ? instr_d :
                    (stall_f /*| stall_m*/) ? 16'h0800 : instr_f;
assign instr_branchTaken = (rst | branchTaken /*| stall_f*/) ? 16'h0800 : instr_stall;            // if the branch is taken, flush the instruction and treat it as NOP
assign halt_f = (~(|instr_branchTaken[15:11]) & ~stall_f) | err_instr_mem;

wire [15:0] pc_dff;

dff HALT_IFID (.d(halt_f), .q(halt_d), .clk(clk), .rst(rst));
dff INSTR_IFID [15:0] (.d(instr_branchTaken), .q(instr_d), .clk(clk), .rst(1'b0/*rst*/));
dff PC_IFID [15:0] (.d((stall_d | stall_m) ? pc_d : pc_f), .q(pc_d), .clk(clk), .rst(rst));
dff ERR (.d(err_instr_mem), .q(err_ifid), .clk(clk), .rst(rst));

endmodule 
`default_nettype wire
