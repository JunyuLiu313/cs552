`default_nettype none
module if_id(   instr_f, pc_f, clk, rst, instr_d, pc_d,
                stall_f, stall_d, halt, branchTaken_m);
input wire [15:0] instr_f, pc_f;
input wire clk, rst, stall_f, branchTaken_m;
output wire [15:0] instr_d, pc_d;
output wire halt, stall_d;


wire [15:0] instr, instr_i, pc;
wire halt_d;

assign halt_d = !(|instr_d[15:11]);
//assign pc	= stall_f ? pc_d : pc_f;

dff HALT_IFID (.q(halt), .d(halt_d), .clk(clk), .rst(rst));


dff_instr INSTR_IFID (.d(instr_f), .q(instr_d), .clk(clk), .rst(1'b0), .flush(branchTaken_m), .stall(stall_f));
dff PC_IFID [15:0] (.d(pc_f), .q(pc_d), .clk(clk), .rst(rst));
dff STAL_IFID   (.d(stall_f), .q(stall_d), .clk(clk), .rst(rst));

endmodule 
`default_nettype wire