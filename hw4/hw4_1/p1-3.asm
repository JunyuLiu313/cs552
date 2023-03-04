// Write your assembly program for Problem 1 (a) #3 here.
// Write your assembly program for Problem 1 (a) #3 here.

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
