// function SimpleFunction.test 2
(SimpleFunction.test) // I think function names are globally unique
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
// add
@SP
A = M - 1	// Set Address to top of stack minus 3
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 3
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
// not
@SP
A = M - 1	// Set Address to top of stack minus 3
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D = M
D = !D		// Bitwise Not D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
@SP
A = M - 1	// Set Address to top of stack minus 3
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 3
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
// push argument 1
@2		// Target argument
A = M		// Offset 1
A = A + 1	// So dumb...
D = M		// D = 1
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// sub
@SP
A = M - 1	// Set Address to top of stack minus 3
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@SP
A = M - 1	// Set Address to top of stack minus 3
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
// return
// frame = LCL // frame is a temp. variable
@LCL
D = M
@13		// Target vm 0
M = D
// retAddr = *(frame-5) // retAddr is a temp. variable
@5
D = D - A
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
