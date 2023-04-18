`default_nettype none
module cache_control (
    // cache signals
    input wire enable,
    input wire clk,
    input wire rst,
    input wire createdump,
    input wire [4:0] tag_in,
    input wire [7:0] index,
    input wire [2:0] offset,
    input wire [15:0] data_in_cache,
    input wire comp,
    input wire write,
    input wire valid_in,
    input wire [15:0] data_out_cache,

    output wire [4:0] tag_out,
    output wire hit,
    output wire dirty,
    output wire valid,
    // output wire err,

    // memory signals             
    input wire [15:0] data_out_mem,
    input wire        stall,
    output wire  [15:0] addr,
    output wire  [15:0] data_in_mem,
    output wire         wr,
    output wire         rd
    );

    parameter IDLE = 4'b0001, COMPARE = 4'b0010, COMPARE2 = 4'b1101;
    parameter WRITEBACK1 = 4'b0011, WRITEBACK2 = 4'b0100, WRITEBACK3 = 4'b0101, WRITEBACK4 = 4'b0110;
    parameter ALLOCATE1 = 4'b0111, ALLOCATE2 = 4'b1000, ALLOCATE3 = 4'b1001;
    parameter ALLOCATE4 = 4'b1010, ALLOCATE5 = 4'b1011, ALLOCATE6 = 4'b1100;

    wire [3:0] state, nxt_state;

    always @(state)
    begin
            // assign nxt_state = 4'b0001;

    end


endmodule
`default_nettype wire