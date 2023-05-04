/*
   CS/ECE 552 Spring '22
  
   Filename        : hazardControl.v
   Description     : This is the module for detecting stall and forwarding in the decode stage.
*/
`default_nettype none
module hazardControl(//inputs
                     Rd_d, Rs_d, Rt_d, 
                     Rd_x, Rd_m, 
                     ResultSel_x, ResultSel_m, ResultSel_d,
                     RegWrite_x, RegWrite_m,
                     opcode_d, opcode_x,
                     Rd_data_x, Rd_data_mStage, Rd_data_memory, // Rd_data_memory is the loaded data from memory
                     Rs_data_d, Rt_data_d,
                     memRead,
                     //outputs 
                     stall, forward, Rs_forward, Rt_forward);
input wire [2:0] Rd_d, Rs_d, Rt_d;
input wire [2:0] Rd_x, Rd_m;
input wire [1:0] ResultSel_x, ResultSel_m, ResultSel_d;
input wire [4:0] opcode_d, opcode_x;
input wire RegWrite_x, RegWrite_m;
input wire [15:0] Rd_data_x, Rd_data_mStage, Rd_data_memory, Rs_data_d, Rt_data_d;
input wire memRead;

output wire stall, forward;
output wire [15:0] Rs_forward, Rt_forward;

/*
   New for Demo3:
      Add forwarding and change stall logic.
      After fully implement forwarding, we only stall when accessing memory
   
   Forwarding:
      if the current instruction Rs and/or Rt is also the Rd to be written in 
      EX stage or MEM stage 
   
   Stall:
      If we have a dependency Rd from the current execute stage but it's a load operation,
      we should wait till the data is loaded from memory 
*/

wire secondReg, imm_load;
// secondReg: 1 if there is Rt, 0 if no Rt in decode stage
assign secondReg = ((opcode_d[4:2] == 3'b110) & opcode_d[1:0] != 2'b00) | (opcode_d[4:2] == 3'b111) | (opcode_d == 5'b10011) | (opcode_d == 5'b10000); 
assign imm_load = (opcode_d == 5'b11000);
                  // | (opcode_d == 5'b10010); 

wire forward_Rs_x, forward_Rs_m;
assign forward_Rs_x = ((Rs_d == Rd_x))? 1'b1 : 1'b0;
assign forward_Rs_m = ((Rs_d == Rd_m))? 1'b1 : 1'b0;

wire branchConflict;
assign branchConflict = ((opcode_d[4:2] == 3'b011) & (Rs_d == Rd_x | Rs_d == Rd_m) ? 1'b1 : 1'b0);

wire forward_Rt_x, forward_Rt_m;
assign forward_Rt_x =  (( Rt_d == Rd_x ) & secondReg) ? 1'b1 : 1'b0;
assign forward_Rt_m =  (( Rt_d == Rd_m ) & secondReg) ? 1'b1 : 1'b0;

wire jump;
assign jump = (opcode_d[4:1] == 4'b0011) & (Rd_x == 3'b111 | Rd_m == 3'b111);

// check if the current instruction in execute stage is ld
wire ld_ex;
assign ld_ex = (opcode_x == 5'b10001);

// comb logic for determining stall
assign stall = ld_ex & RegWrite_x & (forward_Rs_x | forward_Rt_x); // (opcode_d == 5'b10001) ;

// forwarding part
// Rd_data_mStage could be from memory instead of from execute
assign forward = ((forward_Rt_x | forward_Rs_x) & (RegWrite_x) & ~ld_ex) | ((forward_Rt_m | forward_Rs_m) & (RegWrite_m));

/*
   If forwarding happen in memory stage, it could be either Rd originally from execute stage,
   or the data from memory using load instruction
*/
assign Rs_forward = (RegWrite_x & forward_Rs_x) ? Rd_data_x :
                     (RegWrite_m & forward_Rs_m & (memRead)) ? Rd_data_memory :
                     (RegWrite_m & forward_Rs_m) ? Rd_data_mStage :
                     Rs_data_d;
assign Rt_forward = (RegWrite_x & forward_Rt_x) ? Rd_data_x :
                     (RegWrite_m & forward_Rt_m & memRead) ? Rd_data_memory :
                     (RegWrite_m & forward_Rt_m) ? Rd_data_mStage :
                     Rt_data_d;

endmodule
`default_nettype wire
