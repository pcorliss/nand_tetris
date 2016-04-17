# STDIN asm file
# STDOUT hack file

def new_symbol(str, num, symbols)
  # (Symbol): This pseudo-command binds the Symbol to the memory location
  # into which the next command in the program will be stored. It is called ‘‘pseudocommand’’
  # since it generates no machine code.
  symbol_name = str.delete('(').delete(')')
  symbols[symbol_name] = num
  STDERR.puts "New Symbol: #{symbol_name} #{num}"
end

def a_instruction(str)
  "%016b\n" % str.delete('@').to_i
end

def memory(str)
  str.include?('M') ? '1' : '0'
end

DEST_LOOKUP = {
  'D' => 2,
  'A' => 4,
  'M' => 1,
}
def destination(str)
  return '000' if str.nil?
  d_sum = str.each_char.map do |char|
    DEST_LOOKUP[char] || raise("Failure! #{str}")
  end.inject(:+)

  "%03b" % d_sum
end

JUMP_LOOKUP = {
  nil => '000',
  'JGT' => '001',
  'JEQ' => '010',
  'JGE' => '011',
  'JLT' => '100',
  'JNE' => '101',
  'JLE' => '110',
  'JMP' => '111',
}

def jump(str)
  JUMP_LOOKUP[str] || raise("Failure! #{str}")
end

def dest_comp_jump(str)
  dest, x = str.split('=')
  if x.nil? #there was no =
    x = dest
    dest = nil
  end

  comp, jump = x.split(';')

  [dest, comp, jump]
end

COMP_LOOKUP = {
  '0'   => '101010',
  '1'   => '111111',
  '-1'  => '111010',
  'D'   => '001100',
  'A'   => '110000',
  '!D'  => '001101',
  '!A'  => '110001',
  '-D'  => '001111',
  '-A'  => '110011',
  'D+1' => '011111',
  'A+1' => '110111',
  'D-1' => '001110',
  'A-1' => '110010',
  'D+A' => '000010',
  'D-A' => '010011',
  'A-D' => '000111',
  'D&A' => '000000',
  'D|A' => '010101',
}

def comp(str)
  str = str.gsub('M', 'A') if str.include?('M')
  COMP_LOOKUP[str] || '000000'
end

def c_instruction(str)
  return "" if str.nil? || str.empty?
  dest, cmp, jmp = dest_comp_jump(str)
  "111" + memory(cmp) + comp(cmp) + destination(dest) + jump(jmp)
end

def parse(line, num, symbols)
  # Comments Text beginning with two slashes (//) and ending at the end of the line is
  # considered a comment and is ignored.
  comments_removed = line.sub(/\/\/.*$/,'')

  # White Space Space characters are ignored. Empty lines are ignored.
  stripped = comments_removed.gsub(/\s+/,'')

  if stripped.start_with?('@')
    # Constants and Symbols Constants must be non-negative and are written in decimal
    # notation. A user-defined symbol can be any sequence of letters, digits, underscore (_),
    # dot (.), dollar sign ($), and colon (:) that does not begin with a digit.
    a_instruction(stripped)
  elsif stripped.start_with?('(')
    new_symbol(stripped, num, symbols)
    nil
  else
    c_instruction(stripped)
  end
end

INITIAL_SYMBOLS={
  'SP' => 0,
  'LCL' => 1,
  'ARG' => 2,
  'THIS' => 3,
  'THAT' => 4,
  'R0' => 0,
  'R1' => 1,
  'R2' => 2,
  'R3' => 3,
  'R4' => 4,
  'R5' => 5,
  'R6' => 6,
  'R7' => 7,
  'R8' => 8,
  'R9' => 9,
  'R10' => 10,
  'R11' => 11,
  'R12' => 12,
  'R13' => 13,
  'R14' => 14,
  'R15' => 15,
  'SCREEN' => 16384,
  'KBD' => 24576,
}

i=0
symbols=INITIAL_SYMBOLS
ARGF.each_line do |line|
  STDERR.puts "STDIN: #{line}"
  parsed = parse(line, i, symbols)
  if !parsed.nil? && !parsed.empty?
    puts parsed
    i += 1
  end
end
