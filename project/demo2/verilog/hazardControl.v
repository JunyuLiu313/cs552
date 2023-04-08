/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module hazardControl(//inputs
                     Rd_d, Rs_d, Rt_d, 
                     Rd_x, Rd_m, rst, 
                     ResultSel, done,
                     writeReg_x, writeReg_m,
                     //outputs 
                     stall);
input wire [2:0] Rd_d, Rs_d, Rt_d;
input wire [2:0] Rd_x, Rd_m;
input wire [1:0] ResultSel;
input wire done, writeReg_m, writeReg_x, rst;
output wire stall;

wire stall_SD_x, stall_SD_m;
assign stall_SD_x = (Rs_d == Rd_x) ? 1'b1 : 1'b0;
assign stall_SD_m = (Rs_d == Rd_m) ? 1'b1 : 1'b0;

wire stall_RT_x, stall_RT_m;
assign stall_RT_x = !(|ResultSel) ? 1'b0 : 
                     (( Rt_d == Rd_x ) ? 1'b1 : 1'b0);
assign stall_RT_m = !(|ResultSel) ? 1'b0 : 
                     (( Rt_d == Rd_m ) ? 1'b1 : 1'b0);

// comb logic for determining stall
assign stall = (stall_RT_x | stall_RT_m | stall_SD_x | stall_SD_m ) & !done & !rst & (writeReg_x | writeReg_m); 

endmodule
`default_nettype wire
