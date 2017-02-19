// push constant 111
@111		// A = 111
D = A		// D = 111
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 333
@333		// A = 333
D = A		// D = 333
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 888
@888		// A = 888
D = A		// D = 888
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop static 8
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@24		// Target static 8
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// pop static 3
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@19		// Target static 3
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// pop static 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@17		// Target static 1
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push static 3
@19		// Target static 3
D = M		// D = 3
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push static 1
@17		// Target static 1
D = M		// D = 1
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// sub
// pop vm 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// pop vm 1
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
// push static 8
@24		// Target static 8
D = M		// D = 8
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// add
// pop vm 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@13		// Target vm 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// pop vm 1
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
