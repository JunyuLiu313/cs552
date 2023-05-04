/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (Addr, WriteData, halt, MemWrite, MemRead, ReadData, clk, rst, err,
               done, cacheHit, stall_mem,
               halt_wb   
            );

input wire [15:0] Addr, WriteData;
input wire halt, MemWrite, MemRead, clk, rst;

output wire [15:0] ReadData;
output wire err;

// data memory signals
output wire done, cacheHit, stall_mem;

input wire halt_wb;

// memory2c_align D_MEM (.data_out(ReadData), .data_in(WriteData), .addr(Addr),
//                      .enable(MemRead|MemWrite), .wr(MemWrite), .createdump(halt), .clk(clk), .rst(rst), .err(err));

wire stall_dmem;
assign stall_mem = ((MemRead & ~halt_wb) | (MemWrite & ~halt_wb)) & ~done;
wire err_dmem;
assign err = err_dmem & (MemRead | MemWrite);

mem_system DMEM (.DataOut(ReadData), .Done(done), .Stall(stall_dmem), .CacheHit(cacheHit), .err(err_dmem), .Addr(Addr), .DataIn(WriteData), 
               .Rd(MemRead & ~halt_wb), .Wr(MemWrite & ~halt_wb), .createdump(halt), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
