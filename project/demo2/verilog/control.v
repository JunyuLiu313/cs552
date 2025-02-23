`default_nettype none 
module control( //  input
                INSTR,
                //  outputs
                halt, nop, MemRead, RegWrite, MemWrite, MemToReg, jump, JR, branch,
                savePC, RTI, SIIC, OPCODE, FUNC, Rs, Rd, Rt, ZeroExt1, ZeroExt2,
                if1, if2, j, r);

input wire [15:0] INSTR;
output wire [4:0] OPCODE;
output wire [1:0] FUNC;
output wire [2:0] Rs, Rt, Rd;
output wire halt, nop, RegWrite, MemRead, if1, if2, j, r;
output wire MemWrite, MemToReg, savePC, RTI, SIIC, JR, jump, branch, ZeroExt1, ZeroExt2;   

assign if1 = (INSTR[15] & !(|INSTR[14:13]) & !((INSTR[12]) & ~INSTR[11])) |
            (INSTR[15] & ~INSTR[14] & INSTR[13])|
            (~INSTR[15] & INSTR[14] & ~INSTR[13]);
assign if2 = (~INSTR[15] & INSTR[14] & INSTR[13])        |
            (!(|INSTR[15:14]) & INSTR[13] & INSTR[11])  |
            (INSTR[15] & ~INSTR[13] & ~INSTR[11] & (INSTR[14] ^ INSTR[12]));
assign j =  (!(|INSTR[15:14]) & INSTR[13] & ~INSTR[11]);
assign r =  (&INSTR[15:14] & |INSTR[13:11]);

assign halt     = !(|INSTR[15:11]);
assign nop      = (!(|INSTR[15:12])&INSTR[11]);
assign SIIC     = !(|INSTR[15:13]) & INSTR[12] & ~INSTR[11];
assign RTI      = !(|INSTR[15:13]) & INSTR[12] & INSTR[11];
assign savePC   = (!(|INSTR[15:13]) & INSTR[12] & ~INSTR[11]) | (!(|INSTR[15:14]) & INSTR[13:12]);
assign branch   = (&INSTR[14:13]) & ~INSTR[15];
assign jump     = (~INSTR[15] & (&INSTR[14:13])); 
assign JR       = !(|INSTR[15:14]) & INSTR[13] & INSTR[11];
assign MemWrite = ((!(|INSTR[14:11])) | (&INSTR[12:11] & !(|INSTR[14:13]))) & INSTR[15];
assign MemRead  = !(|INSTR[14:12]) & INSTR[15] & INSTR[11];

assign MemToReg =   INSTR[15] & ~INSTR[14] & ~INSTR[13] & ~INSTR[12] & INSTR[11];

assign RegWrite =   (&INSTR[15:13])                             |
                    (&(INSTR[15:14]) & ~INSTR[13])              |    
                    (~INSTR[15] & INSTR[14] & ~INSTR[13])       |
                    (INSTR[15] & ~INSTR[14] & INSTR[13])        |
                    (INSTR[15] & !(|INSTR[14:12]) & INSTR[11])  |
                    (INSTR[15] & !(|INSTR[14:13]) & INSTR[12])  |
                    (!(|INSTR[15:14]) & (&INSTR[13:12]));

//  for RTI instruction PC<-EPC
assign Rs 		= !(|INSTR[15:13]) & (&INSTR[12:11]) ? 3'b111 : INSTR[10:8];
assign Rt 		= INSTR[7:5];
assign FUNC 	= INSTR[1:0];
assign OPCODE   = INSTR[15:11];

wire RsRdOp, R7RdOp;
assign RsRdOp   = 	(INSTR[15] & INSTR[14] 	& !(|INSTR[13:11]))			|
			        (INSTR[15] & ~INSTR[14] & ~INSTR[13] & INSTR[12])   ;
assign R7RdOp   =   !(|INSTR[15:14]) & ( &INSTR[13:12] | (~INSTR[13])&INSTR[12]&~INSTR[11]);
wire [2:0] Rd_i1, Rd_i2;
//  might be error with selection logic when there are PC values is invalid
assign Rd_i1    = (&INSTR[15:14]) & (|INSTR[13:11]) ? INSTR[4:2] : INSTR[7:5]; 
assign Rd_i2    = RsRdOp ? INSTR[10:8] : Rd_i1;
assign Rd       = R7RdOp ? 3'b111 : Rd_i2;

assign ZeroExt1 = ~INSTR[15]&INSTR[14]&~INSTR[13]&INSTR[12];
assign ZeroExt2 = INSTR[15]&~INSTR[14]&~INSTR[13]&INSTR[12];
 endmodule
`default_nettype wire