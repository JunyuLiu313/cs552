/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
`default_nettype none
module cla4b(sum, cOut, inA, inB, cIn);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;

    // YOUR CODE HERE
	wire c1, c2, c3;
	wire g0, g1, g2, g3;
	wire p0, p1, p2, p3;
	wire p0c0AND, p1g0AND, p1p0c0AND;
	wire p2g1AND, p2p1g0AND, p2p1p0c0AND, c3OR0;
	wire p3g2AND, p3p2g1AND, p3p2p1g0AND, p3p2p1p0c0AND;
	wire c4OR0;

	// get g0
	and2 A0(.out(g0), .in1(inA[0]), .in2(inB[0]));
	// get p0
	or2 O0(.out(p0), .in1(inA[0]), .in2(inB[0]));
	// get p0*c0
	and2 A1(.out(p0c0AND), .in1(p0), .in2(cIn));
	// get c1
	or2 O1(.out(c1), .in1(g0), .in2(p0c0AND));
	
	// get c2
	and2 A2(.out(g1), .in1(inA[1]), .in2(inB[1]));
	or2 O2(.out(p1), .in1(inA[1]), .in2(inB[1]));
	and2 A3(.out(p1g0AND), .in1(p1), .in2(g0));
	and3 A30(.out(p1p0c0AND), .in1(p1), .in2(p0), .in3(cIn));
	or3 O30(.out(c2), .in1(g1), .in2(p1g0AND), .in3(p1p0c0AND));
	
	// get c3
	and2 A4(.out(g2), .in1(inA[2]), .in2(inB[2]));
	or2 O3(.out(p2), .in1(inA[2]), .in2(inB[2]));
	and2 A5(.out(p2g1AND), .in1(p2), .in2(g1));
	and3 A31(.out(p2p1g0AND), .in1(p2), .in2(p1), .in3(g0));
	and2 A6(.out(p2p1p0c0AND), .in1(p2), .in2(p1p0c0AND));
	or3 O31(.out(c3OR0), .in1(g2), .in2(p2g1AND), .in3(p2p1g0AND));
	or2 O4(.out(c3), .in1(c3OR0), .in2(p2p1p0c0AND));

	// get c4
	and2 A7(.out(g3), .in1(inA[3]), .in2(inB[3]));
	or2 O5(.out(p3), .in1(inA[3]), .in2(inB[3]));
	and2 A8(.out(p3g2AND), .in1(p3), .in2(g2));
	and3 A32(.out(p3p2g1AND), .in1(p3), .in2(p2), .in3(g1));
	and2 A9(.out(p3p2p1g0AND), .in1(p3), .in2(p2p1g0AND));
	and2 A10(.out(p3p2p1p0c0AND), .in1(p3), .in2(p2p1p0c0AND));
	or3 O32(.out(c4OR0), .in1(g3), .in2(p3g2AND), .in3(p3p2g1AND));
	or3 O33(.out(cOut), .in1(c4OR0), .in2(p3p2p1p0c0AND), .in3(p3p2p1g0AND));

	// adders
	fullAdder1b FA0(.s(sum[0]), .cOut(), .inA(inA[0]), .inB(inB[0]), .cIn(cIn));
	fullAdder1b FA1(.s(sum[1]), .cOut(), .inA(inA[1]), .inB(inB[1]), .cIn(c1));
	fullAdder1b FA2(.s(sum[2]), .cOut(), .inA(inA[2]), .inB(inB[2]), .cIn(c2));
	fullAdder1b FA3(.s(sum[3]), .cOut(), .inA(inA[3]), .inB(inB[3]), .cIn(c3));



endmodule
`default_nettype wire
