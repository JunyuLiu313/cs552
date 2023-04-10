`default_nettype none
module dff_instr(d, q, flush, stall, rst, clk);
input wire [15:0] d;
output wire [15:0] q;
input wire flush, stall, clk, rst;

wire [15:0] d_1, d_2, d_0;
wire [15:0] state;
assign d_2 = stall ? q : d;
assign d_1 = flush ? 16'h0800 : d_2;

dff iDFF [15:0] (.d(d_1), .q(q), .clk(clk), .rst(rst));

endmodule