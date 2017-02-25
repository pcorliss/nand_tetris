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
// function Class1.set 0
(Class1.set) // I think function names are globally unique
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop static 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@Class1.vm.0	// Target static 0 Class1.vm
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
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
// pop static 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@Class1.vm.1	// Target static 1 Class1.vm
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 0
@0		// A = 0
D = A		// D = 0
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
// function Class1.get 0
(Class1.get) // I think function names are globally unique
// push static 0
@Class1.vm.0	// Target static 0 Class1.vm
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push static 1
@Class1.vm.1	// Target static 1 Class1.vm
D = M		// D = 1
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
// function Class2.set 0
(Class2.set) // I think function names are globally unique
// push argument 0
@2		// Target argument
A = M		// Offset 0
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// pop static 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@Class2.vm.0	// Target static 0 Class2.vm
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
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
// pop static 1
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@Class2.vm.1	// Target static 1 Class2.vm
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 0
@0		// A = 0
D = A		// D = 0
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
// function Class2.get 0
(Class2.get) // I think function names are globally unique
// push static 0
@Class2.vm.0	// Target static 0 Class2.vm
D = M		// D = 0
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push static 1
@Class2.vm.1	// Target static 1 Class2.vm
D = M		// D = 1
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
// push constant 6
@6		// A = 6
D = A		// D = 6
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
// call Class1.set 2
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
@7
D = A
@SP
D = M - D
@2
M = D		// ARG = SP-nArgs-5
@SP
D = M
@LCL
M = D		// LCL = SP # repositions LCL for g
@Class1.set
0;JMP
(returnAddress1) // Return
// pop temp 0
@SP
A = M - 1	// Set Address to top of stack minus 1
D = M		// D = RAM[SP]
@5		// Target temp 0
M = D		// Set target to stack var
@SP
M = M - 1	// Decrement SP
// push constant 23
@23		// A = 23
D = A		// D = 23
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// push constant 15
@15		// A = 15
D = A		// D = 15
@SP
A = M		// Set Address to top of stack
M = D		// RAM[SP] = D
@SP
M = M + 1	// Increment SP
// call Class2.set 2
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
@7
D = A
@SP
D = M - D
@2
M = D		// ARG = SP-nArgs-5
@SP
D = M
@LCL
M = D		// LCL = SP # repositions LCL for g
@Class2.set
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
// call Class1.get 0
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
@Class1.get
0;JMP
(returnAddress3) // Return
// call Class2.get 0
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
@Class2.get
0;JMP
(returnAddress4) // Return
// label WHILE
(Sys.init$WHILE)
// goto WHILE
@Sys.init$WHILE
0;JMP
