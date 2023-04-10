// Group 420: Test 2
//
// Test program for WISC-SP23 architecture
// for jump and branch instructions
// for the single-cycle implementation.
//
// CS/ECE 552, Spring 2023
// Bhvait
//
j .Start
.Data1:
halt 
halt
.Data2:
halt
halt
.Start:
lbi r1, 0x0A		// R1 = 10
lbi r2, 0xff		// R2 = -1
lbi r3, 0x03		// R3 = 3

.LoopJump:
beqz r1, .LoopBranch		// branch to End if R1 == 0
add r1, r2, r1		// R1 -= R2
j .LoopJump

add r1, r3, r1
lbi r2, 0x00		// r2 = 0
lbi r3, 0x14		// r3 = 20

.LoopBranch:
addi r2, r2, 0x01	// r2 += 1
sub r4, r2, r3		// r4 = r3 - r2
bnez r4, .LoopBranch
andni r2, r2, 0xff	// r2 = 0
lbi r5, L.Data1
slbi r5, U.Data1
stu r0, r5, 0
halt
stu r2, r5, 0  