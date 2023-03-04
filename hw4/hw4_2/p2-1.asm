// Write your assembly program for Problem 2 (a) #1 here.
.Start:
lbi r1, 0x0A		// R1 = 10
lbi r2, 0xff		// R2 = -1
lbi r3, 0x03		// R3 = 3

.Loop:
beqz r1, .End		// branch to End if R1 == 0
add r1, r2, r1		// R1 -= R2
j .Loop

.End:
add r1, r3, r1
halt