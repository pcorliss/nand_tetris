// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.
D=0
@black
M=D-1

@color
M=0

@last
M=0

(LOOP)
  @KBD
  D=M

  @PAINTBLACK
  D;JGT // PAINT the screen if the KBD is pressed
  @PAINTWHITE
  D;JLE // CLEAR the screen if the KBD is not pressed

(PAINTWHITE)
  // KBD not pressed
  @last
  D=M
  @LOOP
  D;JLE // Short circuit if we're already all white (last == 0)

  @last
  M=0

  @color
  M=0 // White

  @PAINT
  0;JMP // Go To Paint

(PAINTBLACK)
  // KBD Pressed
  @last
  D=M
  @LOOP
  D;JGT // Short circuit if we're already all black (last == 1)

  @last
  M=1

  @black
  D=M
  @color
  M=D

  // If I do nothing here executing will just continue to PAINT
  //@PAINT
  //0;JMP // Go To Paint

(PAINT)
  @i
  M=0
  (PLOOP)
    @i
    D=M // Offset

    @SCREEN
    D=A+D // New Address

    @newAddress
    M=D // Temporarily store a pointer to the new address

    @color
    D=M // Load up our color to paint

    @newAddress
    A=M // Switch to new address location
    M=D // Paint

    @i // Increment i
    M=M+1
    D=M

    @8192
    D=A-D // 8192 - i

    @PLOOP
    D;JGT // PLOOP if (8192 - i) > 0

  @LOOP
  0;JMP
