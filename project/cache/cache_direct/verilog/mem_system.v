/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;
   
   output reg [15:0] DataOut;
   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output reg        err;

   // cache signals
   // inputs 
   wire        enable;
   wire [8:0]  index;
   wire [3:0]  offset;
   wire        comp;
   wire        write;
   wire [4:0]  tag_in;
   wire [15:0] data_in;
   wire        valid_in;
   // outputs
   reg        hit;
   reg        dirty;
   reg [4:0]  tag_out;
   reg [15:0] data_out;
   reg        valid;

   // four-bank mem
   // inputs
   reg [15:0] data_in_mem, Addr_mem;
   reg wr_mem, rd_mem;
   // outputs
   reg [15:0] data_out_mem;
   reg busy;
   // FSM states
   parameter
   IDLE     =  4'b0000,
   ERR      =  4'b0001,
   COMP1    =  4'b0010,
   WB0      =  4'b0011,
   WB1      =  4'b0100,
   WB2      =  4'b0101,
   WB3      =  4'b0110,
   ALLOC0   =  4'b0111,
   ALLOC1   =  4'b1000,
   ALLOC2   =  4'b1001,
   ALLOC3   =  4'b1010,
   ALLOC4   =  4'b1011,
   ALLOC5   =  4'b1100,
   COMP2    =  4'b1101;

   // error signals from cache and 4-ban mem
   wire err_cache, err_mem;
                               
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (data_out),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (err_cache),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (data_out_mem),
                     .stall             (Stall),
                     .busy              (busy),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (Addr_mem),
                     .data_in           (data_in_mem),
                     .wr                (wr_mem),
                     .rd                (rd_mem));
   
   reg [3:0] state, nxt_state;
   dff STATE [3:0] (.q(state), .d(nxt_state), .clk(clk), .rst(rst));  
   assign state = IDLE;

   reg err_allign;

   always @ (state or Rd or Wr)
   begin: FSM_COMB
   
   // defualt logic
   enable   = Rd | Wr;
   err      = err_allign | err_cache | err_mem; 
   valid_in = valid;

      case(state)
         IDLE:
            tag_in      = Addr[15:11];
            index       = Addr[10:3];
            offset      = Addr[2:0];
            data_in     = Wr ? DataIn : 16'h0000;
            DataOut     = data_out;
            nxt_state   =  Addr[0] ? ERR : 
                           enable & !rst ? 
                           COMP1 : IDLE;
         ERR:
            err_allign  = 1'b1;
            nxt_state   = IDLE;
         COMP1:
            comp        = hit;
            CacheHit    = hit & valid;
            Done        = CacheHit;
            write       = Wr;
            nxt_state   =  CacheHit ? IDLE :
                           !dirty ?
                           ALLOC0 : WB0;
         WB0:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b00, {offset[0]}};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1;
            nxt_state   = Stall ? state : WB1;
         WB1:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b01, {offset[0]}};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1;
            nxt_state   = Stall ? state : WB2;
         WB2:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b10, {offset[0]}};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1;
            nxt_state   = Stall ? state : WB3;
         WB3:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b11, {offset[0]}};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1;
            nxt_state   = Stall ? state : ALLOC0;
         ALLOC0:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b00, {offset[0]}};
            write       = 0;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC1;
         ALLOC1:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b01, {offset[0]}};
            write       = 0;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC2;
         ALLOC2:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b10, {offset[0]}};
            data_in     = data_out_mem; 
            write       = 1;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC3;
         ALLOC3:
            comp        = 1'b0;
            Addr_mem    = {{tag_in}, {index}, 2'b11, {offset[0]}};
            data_in     = data_out_mem; 
            write       = 1;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC4;
         ALLOC4:
            comp        = 1'b0;
            data_in     = data_out_mem;
            write       = 1;
            wr_mem      = 0;
            rd_mem      = 0;
            nxt_state   = ALLOC5;
         ALLOC5:
            comp        = 1'b0;
            data_in     = data_out_mem;
            write       = 1;
            wr_mem      = 0;
            rd_mem      = 0;
            nxt_state   = COMP2;
         COMP2:
            Done        = 1'b1;
            write       = Wr;
            data_in     = DataIn;
            comp        = 1'b1;
            nxt_state   = IDLE;
      endcase
   end 
   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
