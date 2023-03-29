`default_nettype none
module err_chk  (//Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeInData, writeEn,
                //Outputs
                err
                );
    input wire [15:0] writeInData;
    input wire [2:0]  read1RegSel, read2RegSel, writeRegSel;
    input wire clk, rst, writeEn;
    output wire err;
    // intermidiate signals
    reg err1, err2, err3, err4, err5, err6, err7;
    assign err = err1 | err2 | err3 | err4 | err5 | err6 | err7;

    always@* begin
        case(writeInData[3:0]) 
        4'b0000: err1 = 1'b0;
        4'b0001: err1 = 1'b0;
        4'b0010: err1 = 1'b0;
        4'b0011: err1 = 1'b0;
        4'b0100: err1 = 1'b0;
        4'b0101: err1 = 1'b0;
        4'b0110: err1 = 1'b0;
        4'b0111: err1 = 1'b0;
        4'b1000: err1 = 1'b0;
        4'b1001: err1 = 1'b0;
        4'b1010: err1 = 1'b0;
        4'b1011: err1 = 1'b0;
        4'b1100: err1 = 1'b0;
        4'b1101: err1 = 1'b0;
        4'b1110: err1 = 1'b0;
        4'b1111: err1 = 1'b0;
        default: err1 = 1'b1;
        endcase
        case(writeInData[7:4]) 
        4'b0000: err2 = 1'b0;
        4'b0001: err2 = 1'b0;
        4'b0010: err2 = 1'b0;
        4'b0011: err2 = 1'b0;
        4'b0100: err2 = 1'b0;
        4'b0101: err2 = 1'b0;
        4'b0110: err2 = 1'b0;
        4'b0111: err2 = 1'b0;
        4'b1000: err2 = 1'b0;
        4'b1001: err2 = 1'b0;
        4'b1010: err2 = 1'b0;
        4'b1011: err2 = 1'b0;
        4'b1100: err2 = 1'b0;
        4'b1101: err2 = 1'b0;
        4'b1110: err2 = 1'b0;
        4'b1111: err2 = 1'b0;
        default: err2 = 1'b1;
        endcase        
        case(writeInData[11:8]) 
        4'b0000: err3 = 1'b0;
        4'b0001: err3 = 1'b0;
        4'b0010: err3 = 1'b0;
        4'b0011: err3 = 1'b0;
        4'b0100: err3 = 1'b0;
        4'b0101: err3 = 1'b0;
        4'b0110: err3 = 1'b0;
        4'b0111: err3 = 1'b0;
        4'b1000: err3 = 1'b0;
        4'b1001: err3 = 1'b0;
        4'b1010: err3 = 1'b0;
        4'b1011: err3 = 1'b0;
        4'b1100: err3 = 1'b0;
        4'b1101: err3 = 1'b0;
        4'b1110: err3 = 1'b0;
        4'b1111: err3 = 1'b0;
        default: err3 = 1'b1;
        endcase
        case(writeInData[15:12]) 
        4'b0000: err4 = 1'b0;
        4'b0001: err4 = 1'b0;
        4'b0010: err4 = 1'b0;
        4'b0011: err4 = 1'b0;
        4'b0100: err4 = 1'b0;
        4'b0101: err4 = 1'b0;
        4'b0110: err4 = 1'b0;
        4'b0111: err4 = 1'b0;
        4'b1000: err4 = 1'b0;
        4'b1001: err4 = 1'b0;
        4'b1010: err4 = 1'b0;
        4'b1011: err4 = 1'b0;
        4'b1100: err4 = 1'b0;
        4'b1101: err4 = 1'b0;
        4'b1110: err4 = 1'b0;
        4'b1111: err4 = 1'b0;
        default: err4 = 1'b1;
        endcase
        case(writeEn)
        1'b0:    err5 = 1'b0;
        1'b1:    err5 = 1'b0;
        default: err5 = 1'b1;
        endcase
        case(rst)
        1'b0:    err6 = 1'b0;
        1'b1:    err6 = 1'b0;
        default: err6 = 1'b1;
        endcase
        case(clk)
        1'b0:    err7 = 1'b0;
        1'b1:    err7 = 1'b0;
        default: err7 = 1'b1;
        endcase

    end
endmodule
`default_nettype wire