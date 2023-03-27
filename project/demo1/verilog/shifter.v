/*
    CS/ECE 552 Spring '23
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
`default_nettype none
module shifter (InBS, ShAmt, ShiftOper, OutBS);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input wire [OPERAND_WIDTH -1:0] InBS;  // Input operand
    input wire [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input wire [NUM_OPERATIONS-1:0] ShiftOper;  // Operation type
    output wire [OPERAND_WIDTH -1:0] OutBS;  // Result of shift/rotate

   /* YOUR CODE HERE */
	
	// left barrel shifter
	// If ShiftOper[1] is 1, rotate left.
	// If ShiftOper[1] is 0, shift left.
	wire [OPERAND_WIDTH-1:0] leftShTemp1, leftShTemp2, leftShTemp3, leftShTemp4;
	wire rightFill1;
	// Shift by 1
	assign rightFill1 = (ShiftOper[1]) ? InBS[OPERAND_WIDTH-1] : 1'b0;
	assign leftShTemp1 = (ShAmt[0]) ? {InBS[14:0], rightFill1} : InBS;
	// Shift by 2
	wire [1:0] rightFill2 = (ShiftOper[1]) ? leftShTemp1[15:14] : 2'b00;
	assign leftShTemp2 = (ShAmt[1]) ? {leftShTemp1[13:0], rightFill2} : leftShTemp1;
	// Shift by 4
	wire [3:0] rightFill3 = (ShiftOper[1]) ? leftShTemp2[15:12] : 4'b0000;
	assign leftShTemp3 = (ShAmt[2]) ? {leftShTemp2[11:0], rightFill3} : leftShTemp2;
	// Shift by 8
	wire [7:0] rightFill4 = (ShiftOper[1]) ? leftShTemp3[15:8] : 8'b0;
	assign leftShTemp4 = (ShAmt[3]) ? {leftShTemp3[7:0], rightFill4} : leftShTemp3;

	// right barrel shifter
	// if ShiftOper[1] is 0, logical shift right
	// if ShiftOper[1] is 1, arithmetic shift right
	wire [OPERAND_WIDTH-1:0] rShftTemp1, rShftTemp2, rShftTemp3, rShftTemp4;
	wire leftFill;
	assign leftFill = (ShiftOper[1]) ? InBS[15] : 1'b0;
	// Shift by 1
	assign rShftTemp1 = (ShAmt[0]) ? {leftFill, InBS[15:1]} : InBS;
	// Shift by 2
	assign rShftTemp2 = (ShAmt[1]) ? {{2{leftFill}}, rShftTemp1[15:2]} : rShftTemp1;
	// Shift by 4
	assign rShftTemp3 = (ShAmt[2]) ? {{4{leftFill}}, rShftTemp2[15:4]} : rShftTemp2;
	// Shift by 8
	assign rShftTemp4 = (ShAmt[3]) ? {{8{leftFill}}, rShftTemp3[15:8]} : rShftTemp3;

	// if ShiftOper[0] is 0, we use left barrel shifter
	// if ShiftOper[0] is 1, we use right barrel shifter
	assign OutBS = (ShiftOper[0]) ? rShftTemp4 : leftShTemp4;
   
endmodule
`default_nettype wire
