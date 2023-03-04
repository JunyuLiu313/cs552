// Write your assembly program for Problem 1 (a) #2 here.
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
