/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (Addr, WriteData, halt, MemWrite, MemRead, ReadData, clk, rst);

input wire [15:0] Addr, WriteData;
input wire halt, MemWrite, MemRead, clk, rst;

output wire [15:0] ReadData;

memory2c (.data_out(ReadData), .data_in(WriteData), .addr(Addr),
          .enable(MemRead|MemWrite), .wr(MemWrite), .createdump(halt), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
