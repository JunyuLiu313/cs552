/*
    CS/ECE 552, Spring '23
    demo 1, testbench 1

    Random testbench for fetch stage
*/
`default_nettype none
module tb_fetch();

reg [15:0] PC, INSTR, currPC;
reg clk, rst;

integer inst_count;
initial begin
    $display("starting tests");
    PC = 16'b0;
    clk = DUT.c0.clk;
    rst = DUT.c0.rst;
    inst_count = 0;
end
fetch f0(.PC(PC), .clk(clk), .rst(rst), .INSTR(INSTR), .currPC(currPC));

always @ (posedge clk) begin
    $display("PC: %8x I: %8x", currPC, INSTR);
    if(rst == 1'b0) begin 
        PC = PC + 2;
    end
    if(inst_count >= 10) begin 
        $stop;
    end
    else begin 
        inst_count = inst_count + 1;
    end 
end

endmodule
`default_nettype wire
