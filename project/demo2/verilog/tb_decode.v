`default_nettype none
module tb_decode();

reg [15:0] PC, INSTR, addr, RsData, RtData, DCaddr, imm, currPC;
reg [4:0] Opcode;
reg [1:0] AluOP;
reg clk, rst, memWrite, memRead, savePC;
integer inst_count;

fetch f1 (.clk(clk), .rst(rst), .PC(PC), .INSTR(INSTR), .currPC(currPC));
decode d1 (.clk(clk), .rst(rst), .INSTR(INSTR), .Opcode(Opcode), .imm(imm), .RsData(RsData), .RtData(RtData), .AluOP(AluOP), .addr(addr), .DCaddr(DCaddr), .memRead(memRead), .memWrite(memWrite), .savePC(savePC));

initial begin
    inst_count = 0;
    clk = DUT.c0.clk;
    rst = DUT.c0.rst;
    PC = 16'b0;
    $display("Starting the test for the decode stage...");
end

always @ (posedge clk) begin
    $display("PC: %8x I: %8x Opcode: %8b RsData: %8x RtData: %8x Imm: %8x\nControl Signals", currPC, INSTR, Opcode, RsData, RtData, imm);
    $display("memRead: %d memWrite: %d AluOP: %d savePC: %d", memRead, memWrite, AluOP, savePC);
    if(rst == 1'b0) begin 
        PC = PC + 2;
    end
    if(inst_count >= 15) begin 
        $stop;
    end
    else begin 
        inst_count = inst_count + 1;
    end 
end    

endmodule
`default_nettype wire
