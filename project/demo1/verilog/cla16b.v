/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
`default_nettype none
module cla16b(sum, cOut, inA, inB, cIn);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;

    // YOUR CODE HERE
	wire c3, c2, c1;
	cla4b cla3[3:0](.sum(sum), .cOut({cOut, c3, c2,c1}), .inA(inA), .inB(inB), .cIn({c3, c2,c1, cIn}));


endmodule
`default_nettype wire
