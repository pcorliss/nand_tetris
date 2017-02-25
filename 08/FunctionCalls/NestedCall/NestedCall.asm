// bootstrap
@256 // SP = 256
D = A
@SP
M = D
// call Sys.init 0
// we assume that nArgs arguments have been pushed
// call segment numArgs
@returnAddress0		// A = returnAddress0
D = A		// D = returnAddress0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@LCL		// A = LCL
D = M		// D = LCL
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@ARG		// A = ARG
D = M		// D = ARG
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@THIS		// A = THIS
D = M		// D = THIS
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@THAT		// A = THAT
D = M		// D = THAT
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@5
D = A
@SP
D = M - D
@2
M = D		// ARG = SP-nArgs-5
@SP
D = M
@LCL
M = D		// LCL = SP # repositions LCL for g
@Sys.init
0;JMP
(returnAddress0) // Return
// function Sys.init 0
(Sys.init) // I think function names are globally unique
// push constant 4000
@4000		// A = 4000
D = A		// D = 4000
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop pointer 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@3		// Target pointer 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 5000
@5000		// A = 5000
D = A		// D = 5000
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop pointer 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@4		// Target pointer 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// call Sys.main 0
// we assume that nArgs arguments have been pushed
// call segment numArgs
@returnAddress1		// A = returnAddress1
D = A		// D = returnAddress1
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@LCL		// A = LCL
D = M		// D = LCL
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@ARG		// A = ARG
D = M		// D = ARG
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@THIS		// A = THIS
D = M		// D = THIS
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@THAT		// A = THAT
D = M		// D = THAT
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@5
D = A
@SP
D = M - D
@2
M = D		// ARG = SP-nArgs-5
@SP
D = M
@LCL
M = D		// LCL = SP # repositions LCL for g
@Sys.main
0;JMP
(returnAddress1) // Return
// pop temp 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@6		// Target temp 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// label LOOP
(Sys.init$LOOP)
// goto LOOP
@Sys.init$LOOP
0;JMP
// function Sys.main 5
(Sys.main) // I think function names are globally unique
@0		// A = 0
D = A		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@0		// A = 0
D = A		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@0		// A = 0
D = A		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@0		// A = 0
D = A		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@0		// A = 0
D = A		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 4001
@4001		// A = 4001
D = A		// D = 4001
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop pointer 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@3		// Target pointer 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 5001
@5001		// A = 5001
D = A		// D = 5001
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop pointer 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@4		// Target pointer 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 200
@200		// A = 200
D = A		// D = 200
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop local 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@1		// Target local
A = M		// Offset 1
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 40
@40		// A = 40
D = A		// D = 40
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop local 2
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@1		// Target local
A = M		// Offset 2
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 6
@6		// A = 6
D = A		// D = 6
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop local 3
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@1		// Target local
A = M		// Offset 3
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 123
@123		// A = 123
D = A		// D = 123
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// call Sys.add12 1
// we assume that nArgs arguments have been pushed
// call segment numArgs
@returnAddress2		// A = returnAddress2
D = A		// D = returnAddress2
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@LCL		// A = LCL
D = M		// D = LCL
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@ARG		// A = ARG
D = M		// D = ARG
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@THIS		// A = THIS
D = M		// D = THIS
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@THAT		// A = THAT
D = M		// D = THAT
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
@6
D = A
@SP
D = M - D
@2
M = D		// ARG = SP-nArgs-5
@SP
D = M
@LCL
M = D		// LCL = SP # repositions LCL for g
@Sys.add12
0;JMP
(returnAddress2) // Return
// pop temp 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@5		// Target temp 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push local 0
@1		// Target local
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push local 1
@1		// Target local
A = M		// Offset 1
A = A + 1	// So dumb...
D = M		// D = 1
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push local 2
@1		// Target local
A = M		// Offset 2
A = A + 1	// So dumb...
A = A + 1	// So dumb...
D = M		// D = 2
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push local 3
@1		// Target local
A = M		// Offset 3
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
D = M		// D = 3
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push local 4
@1		// Target local
A = M		// Offset 4
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
D = M		// D = 4
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@14		// Target vm 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D = M
@14		// Target vm 1
D = M + D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@14		// Target vm 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D = M
@14		// Target vm 1
D = M + D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@14		// Target vm 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D = M
@14		// Target vm 1
D = M + D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@14		// Target vm 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D = M
@14		// Target vm 1
D = M + D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// return
// frame = LCL // frame is a temp. variable
@LCL
D = M
@13		// Target vm 0
M = D
// retAddr = *(frame-5) // retAddr is a temp. variable
@5
A = D - A
D = M
@14		// Target vm 1
M = D
// *ARG = pop // repositions the return value for the caller
@SP
A = M - 1
D = M
@ARG
A = M
M = D
// SP=ARG+1 // restores the caller’s SP
@ARG
D = M + 1
@SP
M = D
// THAT = *(frame-1) // restores the caller’s THAT
@13		// Target vm 0
AM = M - 1
D = M
@THAT
M = D
// THIS = *(frame-2) // restores the caller’s THIS
@13		// Target vm 0
AM = M - 1
D = M
@THIS
M = D
// ARG = *(frame-3) // restores the caller’s ARG
@13		// Target vm 0
AM = M - 1
D = M
@ARG
M = D
// LCL = *(frame-4) // restores the caller’s LCL
@13		// Target vm 0
AM = M - 1
D = M
@LCL
M = D
// goto retAddr // goto returnAddress
@14		// Target vm 1
A = M
0;JMP
// function Sys.add12 0
(Sys.add12) // I think function names are globally unique
// push constant 4002
@4002		// A = 4002
D = A		// D = 4002
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop pointer 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@3		// Target pointer 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 5002
@5002		// A = 5002
D = A		// D = 5002
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop pointer 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@4		// Target pointer 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 12
@12		// A = 12
D = A		// D = 12
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@14		// Target vm 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D = M
@14		// Target vm 1
D = M + D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// return
// frame = LCL // frame is a temp. variable
@LCL
D = M
@13		// Target vm 0
M = D
// retAddr = *(frame-5) // retAddr is a temp. variable
@5
A = D - A
D = M
@14		// Target vm 1
M = D
// *ARG = pop // repositions the return value for the caller
@SP
A = M - 1
D = M
@ARG
A = M
M = D
// SP=ARG+1 // restores the caller’s SP
@ARG
D = M + 1
@SP
M = D
// THAT = *(frame-1) // restores the caller’s THAT
@13		// Target vm 0
AM = M - 1
D = M
@THAT
M = D
// THIS = *(frame-2) // restores the caller’s THIS
@13		// Target vm 0
AM = M - 1
D = M
@THIS
M = D
// ARG = *(frame-3) // restores the caller’s ARG
@13		// Target vm 0
AM = M - 1
D = M
@ARG
M = D
// LCL = *(frame-4) // restores the caller’s LCL
@13		// Target vm 0
AM = M - 1
D = M
@LCL
M = D
// goto retAddr // goto returnAddress
@14		// Target vm 1
A = M
0;JMP
