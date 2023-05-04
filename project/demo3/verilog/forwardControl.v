/*
   CS/ECE 552 Spring '22
  
   Filename        : forwardControl.v
   Description     : This is the module for achieving EX->EX forwarding
                    and MEM->EX forwarding.
*/
`default_nettype none
module forwardControl(
    // inputs
    RtSel_d, RsSel_d, RtData_d, RsData_d,
    Rd_x, Rd_m,  writeData_x, writeData_m,
    RegWrite_x, MemRead_m,
    // outputs
    Rs_data_x, Rt_data_x, forward
);
    // signals from control
    input wire [2:0] RtSel_d, RsSel_d;
    input wire [15:0] RtData_d, RsData_d;
    // Rd from execute and memory
    input wire [2:0] Rd_x, Rd_m;
    input wire [15:0] writeData_x, writeData_m;
    input wire RegWrite_x, MemRead_m;

    // selecting the appropriate Rs and Rt for next execute
    output wire [15:0] Rs_data_x, Rt_data_x;
    output wire forward;

    // if we can do forwarding, select the correct Rd values
    // to be used in EX stage
    assign Rs_data_x = (RegWrite_x & (RsSel_d == Rd_x)) ?  writeData_x:
                    (MemRead_m & (RsSel_d == Rd_m)) ? writeData_m :
                    RsData_d;

    assign Rt_data_x = (RegWrite_x & (RtSel_d == Rd_x)) ? writeData_x :
                    (MemRead_m & (RtSel_d == Rd_m)) ? writeData_m :
                    RtData_d;

    assign forward = (RegWrite_x & (RsSel_d == Rd_x || RtSel_d == Rd_x)) 
                    || (MemRead_m & (RsSel_d == Rd_m || RtSel_d == Rd_m)) ;

endmodule
`default_nettype wire
