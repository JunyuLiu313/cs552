
`default_nettype none
module dff_enable (q, d, clk, rst, enable);

    output wire        q;
    input wire         d;
    input wire         clk;
    input wire         rst;
    input wire         enable;

    reg            state;

    assign #(1) q = state;

    always @(posedge clk) begin
      state = rst? 0 :
            enable ? d :
            state;
    end
endmodule
`default_nettype wire