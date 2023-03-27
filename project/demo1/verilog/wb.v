/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb ( // inputs
            MemtoReg, aluResult, memResult, 
            // outputs
            wbResult);

input wire MemtoReg;
input wire [15:0] aluResult, memResult;

output wire [15:0] wbResult;

assign wbResult = MemtoReg ? memResult : aluResult;

   
endmodule
`default_nettype wire
