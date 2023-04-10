/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
`default_nettype none
module fullAdder1b(s, cOut, inA, inB, cIn);
    output wire s;
    output wire cOut;
    input  wire inA, inB;
    input  wire cIn;

    // YOUR CODE HERE
	wire AxorB, CinandAB, AandB;

	xor2 ixor20(.out(AxorB), .in1(inA), .in2(inB));
	and2 iand21(.out(AandB), .in1(inA), .in2(inB));
	xor2 ixor21(.out(s), .in1(AxorB), .in2(cIn));
	and2 iand20(.out(CinandAB), .in1(AxorB), .in2(cIn));
	or2 ior20(.out(cOut), .in1(AandB), .in2(CinandAB));

endmodule
`default_nettype wire