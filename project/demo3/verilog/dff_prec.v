`default_nettype none
module dff_prec(d, q, clk, rst, stall, flush);
input wire d, clk, rst, flush, stall;
output wire q;
wire d_1, d_2;
assign d_2 = stall ? 1'b0 : d;
// assign d_2 = stall ? q_1 : d;
assign d_1 = flush ? 1'b0 : d_2;
wire q_1; 
dff iDFF(.d(d_1), .q(q_1), .clk(clk), .rst(rst));
assign q = q_1 & !flush;
endmodule
