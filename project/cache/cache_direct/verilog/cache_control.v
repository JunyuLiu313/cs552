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
    output wire [15:0] data_in_cache,
    input wire comp,
    output wire write,
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

    parameter IDLE = 4'b0001, COMPARE1 = 4'b0010, COMPARE2 = 4'b1101;
    parameter WRITEBACK1 = 4'b0011, WRITEBACK2 = 4'b0100, WRITEBACK3 = 4'b0101, WRITEBACK4 = 4'b0110;
    parameter ALLOCATE1 = 4'b0111, ALLOCATE2 = 4'b1000, ALLOCATE3 = 4'b1001;
    parameter ALLOCATE4 = 4'b1010, ALLOCATE5 = 4'b1011, ALLOCATE6 = 4'b1100;

    reg [3:0] state, nxt_state;

    // internal signals
    reg wr_ff, rd_ff, comp_ff, valid_ff, hit_ff, dirty_ff;
    reg write_cache;
    reg [2:0] offset_ff;
    reg [7:0] index_ff;
    reg [4:0] tag_ff;
    reg [15:0] data_ff, memAddr_ff, cacheDataIn;

    always @* case(state) 
            IDLE: begin 
                offset_ff = offset;
                index_ff = index;
                tag_ff = tag_in;
                wr_ff = wr;
                comp_ff = comp;
                data_ff = data_in_cache;
                valid_ff = valid_in;

                // wire cannot be assigned in always block
                // hit = hit_ff;
                // dirty = dirty_ff;
                // tag_out = tag_ff;
                // valid = !dirty_ff & hit_ff | !comp;

                nxt_state = valid_in ? COMPARE1 : nxt_state;
            end

            COMPARE1: begin
                hit_ff = (tag_out == tag_ff) & valid;
                // how to get dirty bit from cache

                nxt_state = dirty_ff ? WRITEBACK1 : ALLOCATE1;
            end

            COMPARE2: begin
                nxt_state = IDLE;
            end

            WRITEBACK1: begin
                memAddr_ff = {tag_ff, index, 3'b000};
                wr_ff = 1'b1;
                rd_ff = 1'b0;
                // how to get data from cache

                nxt_state = WRITEBACK2;
            end

            WRITEBACK2: begin
                memAddr_ff = {tag_ff, index, 3'b010};
                wr_ff = 1'b1;
                rd_ff = 1'b0;
                nxt_state = WRITEBACK3;
            end

            WRITEBACK3: begin
                memAddr_ff = {tag_ff, index, 3'b100};
                wr_ff = 1'b1;
                rd_ff = 1'b0;
                nxt_state = WRITEBACK4;
            end

            WRITEBACK4: begin
                memAddr_ff = {tag_ff, index, 3'b110};
                wr_ff = 1'b1;
                rd_ff = 1'b0;
                nxt_state = ALLOCATE1;
            end

            ALLOCATE1: begin
                memAddr_ff = {tag_ff, index, 3'b000};
                wr_ff = 1'b0;
                rd_ff = 1'b1;
                nxt_state = ALLOCATE2;                
            end

            ALLOCATE2: begin
                memAddr_ff = {tag_ff, index, 3'b010};
                wr_ff = 1'b0;
                rd_ff = 1'b1;
                nxt_state = ALLOCATE3; 
            end

            ALLOCATE3: begin
                offset_ff = 3'b000;
                write_cache = 1'b1;
                cacheDataIn = data_out_mem;
                memAddr_ff = {tag_ff, index_ff, 3'b100};
                wr_ff = 1'b0;
                rd_ff = 1'b1;
                nxt_state = ALLOCATE4;                
            end

            ALLOCATE4: begin
                offset_ff = 3'b010;
                write_cache = 1'b1;
                cacheDataIn = data_out_mem;
                memAddr_ff = {tag_ff, index_ff, 3'b110};
                wr_ff = 1'b0;
                rd_ff = 1'b1;
                nxt_state = ALLOCATE5;
            end

            ALLOCATE5: begin
                offset_ff = 3'b100;
                write_cache = 1'b1;
                cacheDataIn = data_out_mem;
                nxt_state = ALLOCATE6;                
            end

            ALLOCATE6: begin
                offset_ff = 3'b110;
                write_cache = 1'b1;
                cacheDataIn = data_out_mem;
                nxt_state = COMPARE2; 
            end

            default: begin 
                nxt_state = IDLE;
            end
    endcase
    
    dff iState [3:0] (.q(state), .d(nxt_state), .clk(clk), .rst(rst));

endmodule
`default_nettype wire