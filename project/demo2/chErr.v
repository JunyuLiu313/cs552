/*
   CS/ECE 552, Spring '23
   Homework #3, Problem #1

   this module checks the error for rf.v
*/
`default_nettype none
module chErr (err, in);
	input wire in;
	output wire err;

	assign err = (in == 1'bx) ? 1 :
			(in == 1'bz) ? 1 :
			0;

endmodule
`default_nettype wire
