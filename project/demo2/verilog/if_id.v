`default_nettype none
module if_id(   instr_f, pc_f, clk, rst, instr_d, pc_d, halt_d,
                stall_d, branchTaken);
input wire [15:0] instr_f, pc_f;
input wire clk, rst, branchTaken;
output wire [15:0] instr_d, pc_d;
output wire halt_d;
input wire stall_d;


wire [15:0] instr_stall, instr_branchTaken;
wire halt_f;

assign instr_stall = stall_d ? instr_d : instr_f;
assign instr_branchTaken = branchTaken ? 16'h0800 : instr_stall;
assign halt_f = !(|instr_branchTaken[15:11]);

dff HALT_IFID (.d(halt_f), .q(halt_d), .clk(clk), .rst(rst));
dff INSTR_IFID [15:0] (.d(instr_branchTaken), .q(instr_d), .clk(clk), .rst(rst));
dff PC_IFID [15:0] (.d(stall_d ? pc_d : pc_f), .q(pc_d), .clk(clk), .rst(rst));

endmodule 
`default_nettype wire