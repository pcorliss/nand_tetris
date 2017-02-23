// push constant 0
@0		// A = 0
D = A		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop local 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@1		// Target local
A = M		// Offset 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// label LOOP_START
(LOOP_START)
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
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
// pop local 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@1		// Target local
A = M		// Offset 0
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
// pop argument 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@2		// Target argument
A = M		// Offset 0
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
// ifgoto LOOP_START
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
@13		// Target vm 0
D=M
@LOOP_START
D;JNE
// push local 0
@1		// Target local
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
