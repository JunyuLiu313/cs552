/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module forwardControl(
    // inputs
    Rt_d, Rs_d, Rd_x, Rd_m,  writeData_x, writeData_m,
    RegWrite_x, MemToReg_m,
    // outputs
    Rs_x, Rt_x, forward
);
    // signals from control
    input wire [2:0] Rt_d, Rs_d;
    // Rd from execute and memory
    input wire [2:0] Rd_x, Rd_m;
    input wire [15:0] writeData_x, writeData_m;
    input wire RegWrite_x, MemToReg_m;

    // selecting the appropriate Rs and Rt for next execute
    output wire [15:0] Rs_x, Rt_x;
    output wire forward;

    wire XD_forward = (Rd_x);


endmodule
`default_nettype wire
