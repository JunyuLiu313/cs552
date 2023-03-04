// Write your assembly program for Problem 1 (a) #1 here.

// Test for ANDN instruction
lbi r1, 0xff        // expected r1 = 0xffff
lbi r2, 0x0E        // expected r2 = 0x000E
lbi r0, U.Here
slbi r0, L.Here     // r0 contains address of ".Here"
st r2, r0, 0        // .Here should contain the value 0x000E
ld r3, r0, 0        // r3 = 0x000E
andn r4, r1, r2     // expected r4 = 0xfff1
halt
halt
halt
halt
halt
halt
halt
halt
.Here:
halt