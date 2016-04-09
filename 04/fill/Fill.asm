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
M=D-1 // -1 is all bits on or BLACK

@white
M=0 // 0 is all bits off or WHITE

@last
M=0

(LOOP)
  @KBD
  D=M
  // if @last == 0 && @KBD > 0 then PAINT
  // if @last > 0 && @KBD == 0 then CLEAR

  // if @last == 0 && @KBD == 0 then do nothing
  // if @last > 0 && @KBD > 0 then do nothing


  @PAINT
  D;JGT // PAINT the screen if the KBD is pressed
  @CLEAR
  D;JLE // CLEAR the screen if the KBD is not pressed

  @LOOP
  0;JMP // Go back to loop

(PAINT)
  @i
  M=0
  (PLOOP)
    @i
    D=M // Offset


    @SCREEN
    A=A+D // New Address
    D=0
    M=D-1 // Set to BLACK
    @i
    M=M+1
    D=M

    @8192
    D=A-D // 8192 - i

    @PLOOP
    D;JGT // PLOOP if (8192 - i) > 0

  @LOOP
  0;JMP

(CLEAR)
  @i
  M=0
  (CLOOP)
    @i
    D=M // Offset


    @SCREEN
    A=A+D // New Address
    M=0 // Set to WHITE
    @i
    M=M+1
    D=M

    @8192
    D=A-D // 8192 - i

    @CLOOP
    D;JGT // CLOOP if (8192 - i) > 0

  @LOOP
  0;JMP
