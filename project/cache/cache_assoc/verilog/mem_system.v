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

   // error signals from caches and 4-ban mem
   wire err_c0, err_c1, err_mem;  

   // cache signals
   // outputs
   wire         hit_c0, hit_c1;
   wire         valid_c0, valid_c1;
   wire         dirty_c0, dirty_c1;
   wire [4:0]   tag_out_c0, tag_out_c1;
   wire [15:0]  data_out_c0, data_out_c1;
   // inputs
   reg         enable_c0, enable_c1;
   reg [7:0]   index;
   reg [2:0]   offset;
   reg         comp_c0, comp_c1;
   reg         write_c0, write_c1;
   reg [4:0]   tag_in;
   reg [15:0]  data_in;
   reg         valid_in;
   // the corresponding wire signals used for calling cache
   wire        enable_c0_wire, enable_c1_wire;
   wire [7:0]  index_wire;
   wire [2:0]  offset_wire;
   wire        comp_c0_wire, comp_c1_wire;
   wire        write_c0_wire, write_c1_wire;
   wire [4:0]  tag_in_wire;
   wire [15:0] data_in_c_wire;
   wire        valid_in_wire;
   assign   enable_c0_wire = enable_c0;
   assign   enable_c1_wire = enable_c1;
   assign   index_wire = index;
   assign   offset_wire = offset;
   assign   comp_c0_wire = comp_c0;
   assign   comp_c1_wire = comp_c1; 
   assign   write_c0_wire = write_c0;
   assign   write_c1_wire = write_c1;
   assign   tag_in_wire = tag_in;
   assign   data_in_c_wire = data_in;
   assign   valid_in_wire = valid_in;

   // four-bank memory
   // outputs
   wire [15:0]    data_out_mem_wire;
   wire [3:0]     busy_wire;
   wire           stall_mem_wire;
   // inputs
   reg [15:0]     data_in_mem, Addr_mem;
   reg            wr_mem, rd_mem;
   // wire siganls
   wire [15:0]    data_in_mem_wire, Addr_mem_wire;
   wire           wr_mem_wire, rd_mem_wire;
   assign   data_in_mem_wire = data_in_mem;
   assign   Addr_mem_wire = Addr_mem;
   assign   wr_mem_wire = wr_mem;
   assign   rd_mem_wire = rd_mem;

   // fsm states
   reg [3:0]      state, nxt_state;
   wire[3:0]      state_wire, nxt_state_wire;
   assign   nxt_state_wire = nxt_state;


   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out_c0),
                          .data_out             (data_out_c0),
                          .hit                  (hit_c0),
                          .dirty                (dirty_c0),
                          .valid                (valid_c0),
                          .err                  (err_c0),
                          // Inputs
                          .enable               (enable_c0_wire),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in_wire),
                          .index                (index_wire),
                          .offset               (offset_wire),
                          .data_in              (data_in_c_wire),
                          .comp                 (comp_c0_wire),
                          .write                (write_c0_wire),
                          .valid_in             (valid_in_wire));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out_c1),
                          .data_out             (data_out_c1),
                          .hit                  (hit_c1),
                          .dirty                (dirty_c1),
                          .valid                (valid_c1),
                          .err                  (err_c1),
                          // Inputs
                          .enable               (enable_c1_wire),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in_wire),
                          .index                (index_wire),
                          .offset               (offset_wire),
                          .data_in              (data_in_c_wire),
                          .comp                 (comp_c1_wire),
                          .write                (write_c1_wire),
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
   
   // your code here

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

   // replacement policy victimway --------------------------------------------------------
   wire     victimway_d, victimway_q;
   assign   victimway_d = (nxt_state == COMP1) ? ~victimway_q :
                        victimway_q;
   // -------------------------------------------------------------------------------------
   

   // flipflops
   dff iState [3:0] (.q(state_wire), .d(nxt_state_wire), .clk(clk), .rst(rst));
   wire [15:0] Addr_ff, DataIn_ff;
   wire Rd_ff, Wr_ff;
   dff_enable iADDR [15:0] (.q(Addr_ff), .d(Addr), .clk(clk), .rst(rst), .enable(~Stall));  
   dff_enable iDATAIN [15:0] (.q(DataIn_ff), .d(DataIn), .clk(clk), .rst(rst), .enable(~Stall));
   dff_enable iREAD (.q(Rd_ff), .d(Rd), .clk(clk), .rst(rst), .enable(~Stall)); 
   dff_enable iWRITE (.q(Wr_ff), .d(Wr), .clk(clk), .rst(rst), .enable(~Stall));  

   // invert the state of victimway on each read or write of the cache

   dff iVICT (.q(victimway_q), .d(victimway_d), .clk(clk), .rst(rst));
   // keep the way selection the same in one read/write operation
   wire way_ff_d, way_ff_q;
   // choose which way
   /*
      If hit, we choose the way that hits
      Else miss:
         If one of the way is invalid, choose the invalid one.
         If both ways are invalid, choose way 0.
         If both ways are valid, choose victimway.
      Choose 0 if way is 0
      Choose 1 if way is 1
   */
   assign way_ff_d  = (~valid_c0 & ~valid_c1) ? 0 :
                     (~valid_c0) ? 0 :
                     (~valid_c1) ? 1 :
                     victimway_q;
   dff_enable iWAY (.q(way_ff_q), .d(way_ff_d), .clk(clk), .rst(rst), .enable(state == COMP1)); 

   /*
      err_allign ?
   */
   reg            err_allign;

   // FSM
   always @*
   begin
      // default logic
      state       = state_wire;
      nxt_state   = 4'h0;
      err_allign  = 0;
      Stall       = 1'b1;
      Done        = 1'b0;
      CacheHit    = 0;


      
      // cache inputs default values
      enable_c0   =  (state == COMP2) ? ~way_ff_q & Rd_ff : ~way_ff_q & (Rd_ff | Wr_ff);
      enable_c1   =  (state == COMP2) ? way_ff_q & Rd_ff : way_ff_q & (Rd_ff | Wr_ff);
      // enable_c0   = ~victimway_q;
      // enable_c1   = victimway_q;
      tag_in      = Addr_ff[15:11];
      index       = Addr_ff[10:3];
      offset      = Addr_ff[2:0];    
      data_in     = DataIn;  
      comp_c0     = 1'b0;
      comp_c1     = 1'b0;
      write_c0    = 1'b0;
      write_c1    = 1'b0;
      valid_in    = Rd_ff | Wr_ff;
      DataOut     = (state == COMP1) ? ((hit_c0 & valid_c0) ? data_out_c0 : (hit_c1 & valid_c1) ? data_out_c1 : 16'h0000) :
                                       (way_ff_q ? data_out_c1 : data_out_c0);  // otherwise take the output after FF latches victimway

      // memory inputs default values
      Addr_mem    = 16'h0;
      data_in_mem = 16'h0;
      wr_mem      = 0;
      rd_mem      = 0;

      // error output
      err         = err_allign | err_c0 | err_c0 | err_mem;

      case(state)
         IDLE: begin
            // comp_c0     = hit_c0;
            // comp_c1     = hit_c1;
            enable_c0   = 1'b0;
            enable_c1   = 1'b0;
            Stall       = 1'b0;
            nxt_state   = Addr_ff[0] ? ERR :
                           (Rd | Wr) ? COMP1 :
                           IDLE;
         end

         ERR: begin
            err_allign  = 1'b1;
            nxt_state   = IDLE;
         end

         COMP1: begin
            enable_c0   = 1'b1;
            enable_c1   = 1'b1;
            CacheHit    = (hit_c0 & valid_c0) | (hit_c1 & valid_c1);
            Done        = CacheHit;
            comp_c0     = (Rd_ff | Wr_ff); //hit_c0;
            comp_c1     = (Rd_ff | Wr_ff);//hit_c1;
            write_c0    = Wr_ff; //& (hit_c0 & valid_c0);
            write_c1    = Wr_ff; //& (hit_c1 & valid_c1);

            // if choose way 0 and way 0 is dirty, go to writeback.
            // if choose way 1 and way 1 is dirty, go to writeback.
            // otherwise go to allocate
            nxt_state   = CacheHit ? IDLE :
                           ((~way_ff_d & ~dirty_c0) | (way_ff_d & ~dirty_c1)) ? ALLOC0 :
                           WB0;

         end

         WB0: begin
            tag_in      = way_ff_q ? tag_out_c1 : tag_out_c0;
            offset      = 3'b000;
            Addr_mem    = {tag_in, Addr_ff[10:3], offset};
            data_in_mem = way_ff_q ? data_out_c1 : data_out_c0;
            wr_mem      = 1'b1;
            nxt_state   = stall_mem_wire ? state : WB1;
         end

         WB1: begin
            tag_in      = way_ff_q ? tag_out_c1 : tag_out_c0;
            offset      = 3'b010;
            Addr_mem    = {tag_in, Addr_ff[10:3], offset};
            data_in_mem = way_ff_q ? data_out_c1 : data_out_c0;
            wr_mem      = 1'b1;            
            nxt_state   = stall_mem_wire ? state : WB2;
         end

         WB2: begin
            tag_in      = way_ff_q ? tag_out_c1 : tag_out_c0;
            offset      = 3'b100;
            Addr_mem    = {tag_in, Addr_ff[10:3], offset};
            data_in_mem = way_ff_q ? data_out_c1 : data_out_c0;
            wr_mem      = 1'b1;
            nxt_state   = stall_mem_wire ? state : WB3;
         end

         WB3: begin
            tag_in      = way_ff_q ? tag_out_c1 : tag_out_c0;
            offset      = 3'b110;
            Addr_mem    = {tag_in, Addr_ff[10:3], offset};
            data_in_mem = way_ff_q ? data_out_c1 : data_out_c0;
            wr_mem      = 1'b1;
            nxt_state   = ALLOC0;
         end

         ALLOC0: begin
            Addr_mem    = {{Addr_ff[15:3]}, 3'b000};
            rd_mem      = 1;

            nxt_state   = ALLOC1;
         end

         ALLOC1: begin
            Addr_mem    = {{Addr_ff[15:3]}, 3'b010};
            rd_mem      = 1;
            nxt_state   = ALLOC2;
         end

         ALLOC2: begin
            // memory
            Addr_mem    = {{Addr_ff[15:3]}, 3'b100};
            data_in     = data_out_mem_wire; 
            rd_mem      = 1;

            // cache 
            write_c0    = 1;
            write_c1    = 1;
            valid_in    = 1;
            offset      = 3'b000;

            nxt_state   = ALLOC3;
         end

         ALLOC3: begin
            // memory
            Addr_mem    = {{Addr_ff[15:3]}, 3'b110};
            data_in     = data_out_mem_wire; 
            rd_mem      = 1;

            // cache
            write_c0    = 1;
            write_c1    = 1;
            valid_in    = 1;
            offset      = 3'b010; 

            nxt_state   = ALLOC4;            
         end

         ALLOC4: begin
            // cache
            offset      = 3'b100;
            data_in     = data_out_mem_wire;
            write_c0    = 1;
            write_c1    = 1;
            valid_in    = 1;     

            nxt_state   = ALLOC5;
         end

         ALLOC5: begin
            // cache
            offset      = 3'b110;
            data_in     = data_out_mem_wire;
            write_c0    = 1;
            write_c1    = 1;
            valid_in    = 1;  

            nxt_state   = COMP2;
         end

         COMP2: begin
            enable_c0   = ~way_ff_q;
            enable_c1   = way_ff_q;
            data_in     = DataIn;
            write_c0    = Wr_ff;
            write_c1    = Wr_ff;
            comp_c0     = Wr_ff;
            comp_c1     = Wr_ff;
            Done        = 1'b1;
            
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
