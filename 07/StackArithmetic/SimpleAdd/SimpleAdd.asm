// push constant 7
@7		// A = 7
D = A		// D = 7
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 8
@8		// A = 8
D = A		// D = 8
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
@13		// Set target to vm 0
M = D		// Set stack to temp var
@SP
M = M - 1	// Decrement SP
// pop vm 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@14		// Set target to vm 1
M = D		// Set stack to temp var
@SP
M = M - 1	// Decrement SP
@13		// Temp 0
D = M
@14		// Temp 1
D = M + D
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
