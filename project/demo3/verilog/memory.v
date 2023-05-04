/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (Addr, WriteData, halt, MemWrite, MemRead, ReadData, clk, rst, err,
               done, cacheHit, stall_mem   
            );

input wire [15:0] Addr, WriteData;
input wire halt, MemWrite, MemRead, clk, rst;

output wire [15:0] ReadData;
output wire err;

// data memory signals
output wire done, cacheHit, stall_mem;

// memory2c_align D_MEM (.data_out(ReadData), .data_in(WriteData), .addr(Addr),
//                      .enable(MemRead|MemWrite), .wr(MemWrite), .createdump(halt), .clk(clk), .rst(rst), .err(err));

stallmem IMEM (.DataOut(ReadData), .Done(done), .Stall(stall_mem), .CacheHit(cacheHit), .err(err), .Addr(Addr), .DataIn(WriteData), 
               .Rd(MemRead), .Wr(MemWrite), .createdump(halt), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
