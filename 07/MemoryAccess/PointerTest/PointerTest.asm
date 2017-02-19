// push constant 3030
@3030		// A = 3030
D = A		// D = 3030
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
// push constant 3040
@3040		// A = 3040
D = A		// D = 3040
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
// push constant 32
@32		// A = 32
D = A		// D = 32
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop this 2
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@3		// Target this
A = M		// Offset 2
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 46
@46		// A = 46
D = A		// D = 46
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop that 6
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@4		// Target that
A = M		// Offset 6
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push pointer 0
@3		// Target pointer 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push pointer 1
@4		// Target pointer 1
D = M		// D = 1
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
// push this 2
@3		// Target this
A = M		// Offset 2
A = A + 1	// So dumb...
A = A + 1	// So dumb...
D = M		// D = 2
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
// push that 6
@4		// Target that
A = M		// Offset 6
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
D = M		// D = 6
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
