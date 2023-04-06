`default_nettype none
module if_id( instr_f, pc_f, clk, rst, instr_d, pc_d, stall, halt);
input wire [15:0] instr_f, pc_f;
input wire clk, rst, stall;
output wire [15:0] instr_d, pc_d;
output wire halt;

wire [15:0] instr, pc;
wire halt_f;
assign halt_f = !(|instr_d[15:11]);
assign instr 	= stall ? instr_d : instr_f;
assign pc	= stall ? pc_d : pc_f;
dff HALT_IFID (.q(halt), .d(halt_f), .clk(clk), .rst(rst));
dff INSTR_IFID [15:0] (.d(instr), .q(instr_d), .clk(clk), .rst(rst));
dff PC_IFID [15:0] (.d(pc), .q(pc_d), .clk(clk), .rst(rst));

endmodule 
`default_nettype wire
