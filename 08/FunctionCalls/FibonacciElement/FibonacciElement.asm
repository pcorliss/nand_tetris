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
// function Main.fibonacci 0
(Main.fibonacci) // I think function names are globally unique
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 2
@2		// A = 2
D = A		// D = 2
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// lt
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
D = M - D
M = 0
@TRUE1
D;JLT
@14		// Target vm 1
M = 1
(TRUE1)
@14		// Target vm 1
D = M - 1
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// ifgoto IF_TRUE
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D=M
@Main.fibonacci$IF_TRUE
D;JNE
// goto IF_FALSE
@Main.fibonacci$IF_FALSE
0;JMP
// label IF_TRUE
(Main.fibonacci$IF_TRUE)
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
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
// label IF_FALSE
(Main.fibonacci$IF_FALSE)
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 2
@2		// A = 2
D = A		// D = 2
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// sub
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
D = M - D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// call Main.fibonacci 1
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
@Main.fibonacci
0;JMP
(returnAddress2) // Return
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 1
@1		// A = 1
D = A		// D = 1
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// sub
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
D = M - D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// call Main.fibonacci 1
// we assume that nArgs arguments have been pushed
// call segment numArgs
@returnAddress3		// A = returnAddress3
D = A		// D = returnAddress3
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
@Main.fibonacci
0;JMP
(returnAddress3) // Return
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
// function Sys.init 0
(Sys.init) // I think function names are globally unique
// push constant 4
@4		// A = 4
D = A		// D = 4
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// call Main.fibonacci 1
// we assume that nArgs arguments have been pushed
// call segment numArgs
@returnAddress4		// A = returnAddress4
D = A		// D = returnAddress4
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
@Main.fibonacci
0;JMP
(returnAddress4) // Return
// label WHILE
(Sys.init$WHILE)
// goto WHILE
@Sys.init$WHILE
0;JMP
