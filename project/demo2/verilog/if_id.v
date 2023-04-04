`default_nettype none
module if_id( instr_f, pc_f, clk, rst, instr_d, pc_d, nop);
input wire [15:0] instr_f, pc_f;
input wire clk, rst, nop;
output wire [15:0] instr_d, pc_d;

wire [15:0] instr, pc;
assign instr 	= nop ? instr_d : instr_f;
assign pc	= nop ? pc_d : pc_f;
dff INSTR_IFID [15:0] (.d(instr), .q(instr_d), .clk(clk), .rst(rst));
dff PC_IFID [15:0] (.d(pc), .q(pc_d), .clk(clk), .rst(rst));

endmodule 
`default_nettype wire
