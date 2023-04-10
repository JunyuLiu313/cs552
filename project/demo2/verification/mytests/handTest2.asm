lbi r1, 0xff
lbi r5, 0x0e
lbi r6, 0x1c

//  generating an address to store and load from memory
lbi r2, U.HERE
slbi r2, L.HERE
//  store to mem and load from mem
st r1, r2, 0
ld r4, r2, 0

//  test case: ex-mem forwarding
andn r4, r5, r4
st r4, r2, 0    //  this is where ex-mem forwarding should occur

lbi r1, 0x00
lbi r2, 0xdc
lbi r3, 0xae
nop
nop
nop
nop
// waiting for load word to complete 
andn r7, r2, r1 // r7 = 0xdc = 0xdc & ~0x00
// ex-ex forwarding test 1
andn r6, r3, r7 // r6 = 0x22 = 0xae & ~0xdc 
// ex-ex forwarding test 2
andn r5, r6, r7 // r5 = 0x22 = 0x22 & ~0xdc
// ex-ex forwarding test 3
andn r5, r5, r5 // r5 = 0x00 = 0x22 & ~0x22
nop
nop
halt
lbi r1, 0xff
lbi r5, 0x0e
lbi r6, 0x1c

//  generating an address to store and load from memory
lbi r2, U.HERE
slbi r2, L.HERE
//  store to mem and load from mem
st r1, r2, 0
ld r4, r2, 0

//  test case: ex-mem forwarding
andn r4, r5, r4
st r4, r2, 0    //  this is where ex-mem forwarding should occur

halt
halt
halt
halt
halt
halt
halt
halt
halt
.HERE:
halt