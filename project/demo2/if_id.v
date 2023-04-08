`default_nettype none
module if_id(   instr_f, pc_f, clk, rst, instr_d, pc_d,
                stall_f, halt, branchTaken_x);
input wire [15:0] instr_f, pc_f;
input wire clk, rst, stall_f;
output wire [15:0] instr_d, pc_d;
output wire halt;

input wire branchTaken_x;

wire [15:0] instr, instr_i, pc;
wire halt_f;

assign halt_f = !(|instr_f[15:11]);
assign instr_i = (stall_f) ? instr_d : instr_f;
assign instr = (branchTaken_x) ? 16'h0800 : instr_i;
assign pc	= stall_f ? pc_d : pc_f;

dff HALT_IFID (.q(halt), .d(halt_f), .clk(clk), .rst(rst));
dff INSTR_IFID [15:0] (.d(instr), .q(instr_d), .clk(clk), .rst(rst));
dff PC_IFID [15:0] (.d(pc), .q(pc_d), .clk(clk), .rst(rst));

endmodule 
`default_nettype wire