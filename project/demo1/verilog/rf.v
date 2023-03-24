/*
   CS/ECE 552, Spring '23
   Homework #3, Problem #1
  
   This module creates a 16-bit register file.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
`default_nettype none
module rf (
           // Outputs
           read1OutData, read2OutData, err,
           // Inputs
           clk, rst, read1RegSel, read2RegSel, writeRegSel, writeInData, writeEn
           );
   parameter REGISTER_WIDTH = 16; 
   parameter SEL_WIDTH = 3;
   input wire       clk, rst;
   input wire [SEL_WIDTH-1:0] read1RegSel;
   input wire [SEL_WIDTH-1:0] read2RegSel;
   input wire [SEL_WIDTH-1:0] writeRegSel;
   input wire [REGISTER_WIDTH-1:0] writeInData;
   input wire        writeEn;

   output wire [REGISTER_WIDTH-1:0] read1OutData;
   output wire [REGISTER_WIDTH-1:0] read2OutData;
   output wire        err;

   /* YOUR CODE HERE */
	// declare the registers in the register file
	wire [REGISTER_WIDTH-1:0] registers[7:0];

	// read registers
	assign read1OutData = (read1RegSel == 3'b000) ? registers[0] :
				(read1RegSel == 3'b001) ? registers[1] :
				(read1RegSel == 3'b010) ? registers[2] :
				(read1RegSel == 3'b011) ? registers[3] :
				(read1RegSel == 3'b100) ? registers[4] :
				(read1RegSel == 3'b101) ? registers[5] :
				(read1RegSel == 3'b110) ? registers[6] :
				registers[7];

	assign read2OutData = (read2RegSel == 3'b000) ? registers[0] :
				(read2RegSel == 3'b001) ? registers[1] :
				(read2RegSel == 3'b010) ? registers[2] :
				(read2RegSel == 3'b011) ? registers[3] :
				(read2RegSel == 3'b100) ? registers[4] :
				(read2RegSel == 3'b101) ? registers[5] :
				(read2RegSel == 3'b110) ? registers[6] :
				registers[7];
	
	// write registers
	// determine which register to write
	wire writeReg0 = writeEn & ~writeRegSel[2] & ~writeRegSel[1] & ~writeRegSel[0];
	wire writeReg1 = writeEn & ~writeRegSel[2] & ~writeRegSel[1] & writeRegSel[0];
	wire writeReg2 = writeEn & ~writeRegSel[2] & writeRegSel[1] & ~writeRegSel[0];
	wire writeReg3 = writeEn & ~writeRegSel[2] & writeRegSel[1] & writeRegSel[0];
	wire writeReg4 = writeEn & writeRegSel[2] & ~writeRegSel[1] & ~writeRegSel[0];
	wire writeReg5 = writeEn & writeRegSel[2] & ~writeRegSel[1] & writeRegSel[0];
	wire writeReg6 = writeEn & writeRegSel[2] & writeRegSel[1] & ~writeRegSel[0];
	wire writeReg7 = writeEn & writeRegSel[2] & writeRegSel[1] & writeRegSel[0];
	// write to register
	wire [REGISTER_WIDTH-1:0] writeData0 = (writeReg0) ? writeInData : registers[0];
	wire [REGISTER_WIDTH-1:0] writeData1 = (writeReg1) ? writeInData : registers[1];
	wire [REGISTER_WIDTH-1:0] writeData2 = (writeReg2) ? writeInData : registers[2];
	wire [REGISTER_WIDTH-1:0] writeData3 = (writeReg3) ? writeInData : registers[3];
	wire [REGISTER_WIDTH-1:0] writeData4 = (writeReg4) ? writeInData : registers[4];
	wire [REGISTER_WIDTH-1:0] writeData5 = (writeReg5) ? writeInData : registers[5];
	wire [REGISTER_WIDTH-1:0] writeData6 = (writeReg6) ? writeInData : registers[6];
	wire [REGISTER_WIDTH-1:0] writeData7 = (writeReg7) ? writeInData : registers[7];

	// call diff module to write to the register
	dff idiff0 [REGISTER_WIDTH-1:0] (.q(registers[0]), .d(writeData0), .clk(clk), .rst(rst));
	dff idiff1 [REGISTER_WIDTH-1:0] (.q(registers[1]), .d(writeData1), .clk(clk), .rst(rst));
	dff idiff2 [REGISTER_WIDTH-1:0] (.q(registers[2]), .d(writeData2), .clk(clk), .rst(rst));
	dff idiff3 [REGISTER_WIDTH-1:0] (.q(registers[3]), .d(writeData3), .clk(clk), .rst(rst));
	dff idiff4 [REGISTER_WIDTH-1:0] (.q(registers[4]), .d(writeData4), .clk(clk), .rst(rst));
	dff idiff5 [REGISTER_WIDTH-1:0] (.q(registers[5]), .d(writeData5), .clk(clk), .rst(rst));
	dff idiff6 [REGISTER_WIDTH-1:0] (.q(registers[6]), .d(writeData6), .clk(clk), .rst(rst));
	dff idiff7 [REGISTER_WIDTH-1:0] (.q(registers[7]), .d(writeData7), .clk(clk), .rst(rst));

	// check errors
	wire [3+SEL_WIDTH*3+REGISTER_WIDTH-1:0] errData;
	chErr ichErr0 [3+SEL_WIDTH*3+REGISTER_WIDTH-1:0] (.err(errData), .in({clk, rst, read1RegSel, 
						read2RegSel, writeRegSel, writeInData, writeEn}));
	assign err = |errData;
	

endmodule
`default_nettype wire
