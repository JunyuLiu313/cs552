/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb ( // inputs
            clk, rst, MemtoReg, exResult, memResult, 
            // outputs
            wbResult);

input wire MemtoReg, clk, rst;
input wire [15:0] exResult, memResult;

output wire [15:0] wbResult;

assign wbResult = MemtoReg ? memResult : exResult;

   
endmodule
`default_nettype wire
