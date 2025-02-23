
 

/*
   CS/ECE 552 Spring '22
  
   Filename        : btr.v
   Description     : This is the module to perform BTR Rd, Rs
*/

`default_nettype none
module btr(Rs, Rd);
	input wire [15:0] Rs;
	output wire [15:0] Rd;

	assign Rd[0] = Rs[15];
	assign Rd[1] = Rs[14];
	assign Rd[2] = Rs[13];
	assign Rd[3] = Rs[12];
	assign Rd[4] = Rs[11];
	assign Rd[5] = Rs[10];
	assign Rd[6] = Rs[9];
	assign Rd[7] = Rs[8];
	assign Rd[8] = Rs[7];
	assign Rd[9] = Rs[6];
	assign Rd[10] = Rs[5];
	assign Rd[11] = Rs[4];
	assign Rd[12] = Rs[3];
	assign Rd[13] = Rs[2];
	assign Rd[14] = Rs[1];
	assign Rd[15] = Rs[0];

endmodule
`default_nettype wire