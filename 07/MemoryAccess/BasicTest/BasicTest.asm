// push constant 10
@10		// A = 10
D = A		// D = 10
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
// push constant 21
@21		// A = 21
D = A		// D = 21
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 22
@22		// A = 22
D = A		// D = 22
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop argument 2
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@2		// Target argument
A = M		// Offset 2
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// pop argument 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@2		// Target argument
A = M		// Offset 1
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 36
@36		// A = 36
D = A		// D = 36
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop this 6
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@3		// Target this
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
// push constant 42
@42		// A = 42
D = A		// D = 42
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 45
@45		// A = 45
D = A		// D = 45
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop that 5
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@4		// Target that
A = M		// Offset 5
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// pop that 2
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@4		// Target that
A = M		// Offset 2
A = A + 1	// So dumb...
A = A + 1	// So dumb...
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 510
@510		// A = 510
D = A		// D = 510
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop temp 6
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@11		// Target temp 6
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
// push that 5
@4		// Target that
A = M		// Offset 5
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
A = A + 1	// So dumb...
D = M		// D = 5
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
// push this 6
@3		// Target this
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
// push this 6
@3		// Target this
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
// push temp 6
@11		// Target temp 6
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
