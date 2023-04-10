// Group 420: Test 2
//
// Test program for WISC-SP23 architecture
// for jump and branch instructions
// for the single-cycle implementation.
//
// CS/ECE 552, Spring 2023
// ChatGPT and Bhvait
//
lbi r0, 0
lbi r1, 0xffff
j .Label1
halt

// Load and store instructions
ld r2, r0, 0
lbi r3, 1
stu r3, r0, 2

// Branching and jump instructions
.Label1:
addi r1, r7, 0
jal .Label2

// Return address label for .Label2
.RetAddr2:
.Label2:
addi r5, r7, 0
addi r3, r0, -9
jalr r3, 9

// Return address label for .Label2
.RetAddr3:
.Label3:
lbi r6, 1
stu r1, r6, 1

// Control flow instructions
lbi r0, 0
lbi r1, 1
lbi r2, -1
beqz r0, .Label5
bltz r1, .Death
beqz r1, .Death
bgez r0, .Label9
slbi r4, L.Label4
add r4, r4, r0
add r5, r5, r7
lbi r7, 0x55
jr r4, 100
addi r7, r7, 15
bnez r0, .Death
addi r6, r6, 2
bnez r1, .Label6
bnez r2, .Label7

// Labels
.Label4:
addi r6, r6, 3
j .Label8
.Label5:
addi r6, r6, 4
j .Label8
.Label6:
addi r6, r6, 5
j .Label8
.Label7:
addi r6, r6, 6
j .Label8
.Label8:
addi r6, r6, 7
j .Label9
.Label9:
addi r6, r6, 8
halt
.Death:
lbi r6, 9
halt