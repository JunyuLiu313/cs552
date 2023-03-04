// Write your assembly program for Problem 2 (a) #2 here.
.Start:
lbi r2, 0x00		// r2 = 0
lbi r3, 0x14		// r3 = 20

.Loop:
addi r2, r2, 0x01	// r2 += 1
sub r4, r2, r3		// r4 = r3 - r2
bnez r4, .Loop
andni r2, r2, 0xff	// r2 = 0
halt