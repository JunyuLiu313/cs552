/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module hazardControl(//inputs
                     Rd_d, Rs_d, Rt_d, 
                     Rd_x, Rd_m, 
                     ResultSel_x, ResultSel_m, ResultSel_d,
                     RegWrite_x, RegWrite_m,
                     opcode, branch,
                     //outputs 
                     stall);
input wire [2:0] Rd_d, Rs_d, Rt_d;
input wire [2:0] Rd_x, Rd_m;
input wire [1:0] ResultSel_x, ResultSel_m, ResultSel_d;
input wire [4:0] opcode;
input wire RegWrite_x, RegWrite_m, branch;
output wire stall;

wire secondReg, imm_load;
assign secondReg = ((opcode[4:2] == 3'b110) & opcode[1:0] != 2'b00) | (opcode[4:2] == 3'b111) | (opcode == 5'b10011) | (opcode == 5'b10000); 
assign imm_load = (opcode == 5'b11000);
                  // | (opcode == 5'b10010); 
wire stall_SD_x, stall_SD_m;
assign stall_SD_x = ((Rs_d == Rd_x) & !imm_load)? 1'b1 : 1'b0;
assign stall_SD_m = ((Rs_d == Rd_m) & !imm_load)? 1'b1 : 1'b0;

wire branchConflict;
assign branchConflict = ((opcode[4:2] == 3'b011) & (Rs_d == Rd_x | Rs_d == Rd_m) ? 1'b1 : 1'b0);

wire stall_RT_x, stall_RT_m;
assign stall_RT_x =  (( Rt_d == Rd_x ) & secondReg) ? 1'b1 : 1'b0;
assign stall_RT_m =  (( Rt_d == Rd_m ) & secondReg) ? 1'b1 : 1'b0;

wire jump;
assign jump = (opcode[4:2] == 3'b001);

// comb logic for determining stall
assign stall = (((stall_RT_x | stall_SD_x) & (RegWrite_x)) | ((stall_RT_m | stall_SD_m) & (RegWrite_m)) | branchConflict) & ~jump;

endmodule
`default_nettype wire
