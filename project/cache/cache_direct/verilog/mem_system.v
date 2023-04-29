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

/////////////////////////////////////////////////////////////////////
//////////////////////   Internal Signals       /////////////////////
/////////////////////////////////////////////////////////////////////
   // cache signals
   // inputs 
   reg        enable;
   reg [7:0]  index;
   reg [2:0]  offset;
   reg        comp;
   reg        write;
   reg [4:0]  tag_in;
   reg [15:0] data_in;
   reg        valid_in;
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
   reg [3:0] busy;

   // wire signals to connect to cache and memory modules
   wire        enable_wire;
   wire [7:0]  index_wire;
   wire [2:0]  offset_wire;
   wire        comp_wire;
   wire        write_wire;
   wire [4:0]  tag_in_wire;
   wire [15:0] data_in_wire;
   wire        valid_in_wire;
   // outputs
   wire        hit_wire;
   wire        dirty_wire;
   wire [4:0]  tag_out_wire;
   wire [15:0] data_out_wire;
   wire        valid_wire;

   // four-bank mem
   // inputs
   wire [15:0]    data_in_mem_wire, Addr_mem_wire;
   wire           wr_mem_wire, rd_mem_wire;
   // outputs
   wire [15:0]    data_out_mem_wire;
   wire [3:0]     busy_wire;
   wire           stall_mem_wire;

   // error signals from cache, 4-bank mem, and FSM
   wire err_cache, err_mem;
   reg err_allign;

   // state signals
   reg [3:0] state, nxt_state;
   wire [3:0] state_wire, nxt_state_wire;

   // flipflop the inputs
   wire [15:0] Addr_ff, DataIn_ff;
   wire Rd_ff, Wr_ff;

   // misc signals
   reg [4:0] tag_ff_d;

/////////////////////////////////////////////////////////////////////
//////////////////////    Assign statements     /////////////////////
/////////////////////////////////////////////////////////////////////

   // assign all the reg signals to their corresponding wire signals
   assign enable_wire      = enable;
   assign index_wire       = index;
   assign offset_wire      = offset;
   assign comp_wire        = comp;
   assign write_wire       = write;
   assign tag_in_wire      = tag_in;
   assign data_in_wire     = data_in ;
   assign valid_in_wire    = valid_in;
   assign data_in_mem_wire = data_in_mem;
   assign Addr_mem_wire    = Addr_mem;
   assign wr_mem_wire      = wr_mem;
   assign rd_mem_wire      = rd_mem;
   assign nxt_state_wire   = nxt_state; 
   // FSM states
   localparam [3:0]
   IDLE     =  4'b0000,
   ERR      =  4'b1111,
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
   COMP2    =  4'b1101,
   DONE     =  4'b1110;


                               
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out_wire),
                          .data_out             (data_out_wire),
                          .hit                  (hit_wire),
                          .dirty                (dirty_wire),
                          .valid                (valid_wire),
                          .err                  (err_cache),
                          // Inputs
                          .enable               (enable_wire),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in_wire),
                          .index                (index_wire),
                          .offset               (offset_wire),
                          .data_in              (data_in_wire),
                          .comp                 (comp_wire),
                          .write                (write_wire),
                          .valid_in             (valid_in_wire));

   four_bank_mem mem(// Outputs
                     .data_out          (data_out_mem_wire),
                     .stall             (stall_mem_wire),
                     .busy              (busy_wire),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (Addr_mem_wire),
                     .data_in           (data_in_mem_wire),
                     .wr                (wr_mem_wire),
                     .rd                (rd_mem_wire));
   

/////////////////////////////////////////////////////////////////////
//////////////////////  DFF Module Declaration  /////////////////////
/////////////////////////////////////////////////////////////////////

   dff STATE [3:0] (.q(state_wire), .d(nxt_state_wire), .clk(clk), .rst(rst));
   dff_enable ADDR [15:0] (.q(Addr_ff), .d(Addr), .clk(clk), .rst(rst), .enable(~Stall));  
   dff_enable DATAIN [15:0] (.q(DataIn_ff), .d(DataIn), .clk(clk), .rst(rst), .enable(~Stall));
   dff_enable READ (.q(Rd_ff), .d(Rd), .clk(clk), .rst(rst), .enable(~Stall)); 
   dff_enable WRITE (.q(Wr_ff), .d(Wr), .clk(clk), .rst(rst), .enable(~Stall));
     
/////////////////////////////////////////////////////////////////////
//////////////////////  FSM comb and seq logic  /////////////////////
/////////////////////////////////////////////////////////////////////

always @*
   begin
   
   // defualt logic
   // 4 bank mem signals
   data_out_mem   = data_out_mem_wire;
   busy           = busy_wire;
   
   // mem system level signals
   Done     = 1'b0;
   Stall    = 1'b1;
   CacheHit = 1'b0;
   DataOut  = data_out_wire;
   data_in  = DataIn;

   // cache inputs
   comp        = 0;
   tag_in      = Addr_ff[15:11];
   index       = Addr_ff[10:3];
   offset      = Addr_ff[2:0];
   Stall       = 1'b1;
   dirty       = dirty_wire;
   data_out    = data_out_wire;   
   enable      = 0;
   write       = 1'b0;

   err         = 0;
   err_allign  = 0;

   state       = state_wire;
   nxt_state   = 4'h0;
   

      case(state)
         IDLE: begin

            tag_in      = Addr[15:11];
            index       = Addr[10:3];
            offset      = Addr[2:0];
            valid_in    = Rd | Wr; 
            write       = Wr;
            comp        = Rd | Wr;
            enable      = Rd | Wr;
            data_in     = Wr ? DataIn : 16'h0000;

            data_in_mem = DataIn_ff;
            Addr_mem    = 16'h0;
            wr_mem      = 0;
            rd_mem      = 0;

            Stall       = 0;
            CacheHit    = hit_wire & valid_in_wire;
            Done        = CacheHit & valid_in_wire & (~dirty | ~Wr);

            nxt_state   =  Addr[0]? ERR:
                           (~hit_wire & dirty_wire) ? WB0:
                           (~hit_wire & ~dirty_wire & valid_in_wire) ? ALLOC0 : 
                           (~valid_in_wire | (hit_wire & valid_wire)) ?  IDLE : ALLOC0;

         end

         ERR: begin
            err_allign  = 1'b1;
            err         = err_allign | err_cache | err_mem;
            nxt_state   = IDLE;
         end

         WB0: begin
            tag_in      = tag_out_wire;
            comp        = 1'b0;
            enable      = 1'b1;

            Addr_mem    = {tag_out_wire, Addr_ff[10:3], 3'b000};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1'b1;
            nxt_state   = stall_mem_wire ? state : WB1;
            // read word 0 from cache
            offset      = 3'b000;
         end

         WB1: begin
            comp        = 1'b0;
            enable      = 1'b1;

            Addr_mem    = {tag_out_wire, Addr_ff[10:3], 3'b010};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1'b1;
            nxt_state   = stall_mem_wire ? state : WB2;
            // read word 1 from cache
            offset      = 3'b010;
         end

         WB2: begin
            comp        = 1'b0;
            enable      = 1'b1;

            Addr_mem    = {tag_out_wire, Addr_ff[10:3], 3'b100};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1'b1;
            nxt_state   = stall_mem_wire ? state : WB3;
            // read word 2 from cache
            offset      = 3'b100;
         end

         WB3: begin
            comp        = 1'b0;
            enable      = 1'b1;

            Addr_mem    = {tag_out_wire, Addr_ff[10:3], 3'b110};
            data_in_mem = data_out;
            write       = 0;
            wr_mem      = 1'b1;
            nxt_state   = ALLOC0;
            // read word 3 from cache
            offset      = 3'b110;
         end

         ALLOC0: begin
            comp        = 1'b0;
            Addr_mem    = {{Addr_ff[15:3]}, 3'b000};
            write       = 0;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC1;
         end

         ALLOC1: begin
            comp        = 1'b0;
            Addr_mem    = {{Addr_ff[15:3]}, 3'b010};
            write       = 0;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC2;
         end

         ALLOC2: begin
            comp        = 1'b0;
            offset      = 3'b000;
            enable      = 1'b1;

            Addr_mem    = {{Addr_ff[15:3]}, 3'b100};
            data_in     = data_out_mem; 
            write       = 1;
            valid_in    = 1;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC3;
         end

         ALLOC3: begin
            comp        = 1'b0;
            offset      = 3'b010;
            enable      = 1'b1;

            Addr_mem    = {{Addr_ff[15:3]}, 3'b110};
            data_in     = data_out_mem; 
            write       = 1;
            valid_in    = 1;
            wr_mem      = 0;
            rd_mem      = 1;
            nxt_state   = ALLOC4;
         end

         ALLOC4: begin
            comp        = 1'b0;
            offset      = 3'b100;
            enable      = 1'b1;

            data_in     = data_out_mem;
            write       = 1;
            valid_in    = 1;
            wr_mem      = 0;
            rd_mem      = 0;
            nxt_state   = ALLOC5;
         end

         ALLOC5: begin
            comp        = 1'b0;
            offset      = 3'b110;
            enable      = 1'b1;

            data_in     = data_out_mem;
            write       = 1;
            valid_in    = 1;
            wr_mem      = 0;
            rd_mem      = 0;
            nxt_state   = DONE;
         end

         // assign the data output
         DONE: begin
            Done        = 1'b1;
            enable      = 1'b1;
            comp        = Wr_ff;
            write       = Wr_ff;
            nxt_state   = IDLE;
         end

         default: begin 
            nxt_state   = IDLE;
         end
      endcase
   end 
   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:   