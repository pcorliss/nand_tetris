#!/usr/bin/env ruby

# VM Translator
# In: 1 or more VM files, either a vm file or directory of vm files
# Out: asm file

# Hint: Emit a comment that shows the command
# // push constant 7
# @17
# D=A

# 0. Load *VME.tst into vm, run test script, inspect operation
# 1. Use translator to translate *.vm -> *.asm
# 2. Inspect generated code, make sure it looks good
# 3. Load *.tst into CPU Emulator
# 4. Run test script, inspect results

# Two Parts
# Parser
# CodeWriter

# Missing `function` and `return`
# That's okay, will happen in project 8
# test scripts should handle it

class Command
  def initialize(segment, i)
    @segment = segment
    @i = i
  end

  def self.parse(cmd, segment, i)
    if cmd == 'if-goto'
      IfGoto.new(segment, i)
    else
      Object.const_get(cmd.capitalize).new(segment, i)
    end
  end

  def original_command
    out = "#{self.class.to_s.downcase}"
    out << " #{@segment}" if !@segment.empty?
    out << " #{@i}" if !@i.empty?
    out
  end

  def increment_sp
    <<-EOF
      @SP
      M = M + 1\t// Increment SP
    EOF
  end

  def decrement_sp
    <<-EOF
      @SP
      M = M - 1\t// Decrement SP
    EOF
  end

  def set_stack(var_name)
    <<-EOF
      @SP
      A = M\t\t// Set Address to top of stack
      M = #{var_name}\t\t// RAM[SP] = #{var_name}
      #{increment_sp}
    EOF
  end

  def get_stack
    <<-EOF
      @SP
      A = M - 1\t// Set Address to top of stack minus 1
      D = M\t\t// D = RAM[SP]
    EOF
  end

  OFFSET = {
    'vm' => 13,
    'temp' => 5,
    'static' => 16,
    'pointer' => 3,
    'this' => 3, # pointers
    'that' => 4, # pointers
    'argument' => 2,
    'local' => 1,
  }

  DIRECT_SEGMENTS = ['vm', 'temp', 'static', 'pointer']

  def offset(segment)
    OFFSET[segment]
  end

  def offset_str(index)
    if index.to_i == 0
      "\t\t"
    else
      " + #{index}\t"
    end
  end

  def target(segment = @segment, index = @i)
    if DIRECT_SEGMENTS.include? segment
      <<-EOF
        @#{index.to_i + offset(segment)}\t\t// Target #{segment} #{index}
      EOF
    else
      out = <<-EOF
        @#{offset(segment)}\t\t// Target #{segment}
        A = M\t\t// Offset #{index}
      EOF
      index.to_i.times do
        out << "A = A + 1\t// So dumb...\n"
      end
      out
    end
  end

  def cmd_write
    "// #{original_command}\n#{write}"
  end
end

# True == -1
# False == 0

class Add < Command
  def write
    <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = M + D
      #{set_stack('D')}
    EOF
  end
end

class Sub < Command
  def write
    <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = M - D
      #{set_stack('D')}
    EOF
  end
end

class Eq < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = M - D

      @TRUE#{$label_counter}
      D;JEQ\t\t// If D is zero skip next arg
      D = 1
      (TRUE#{$label_counter})
      D = D - 1
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

class Lt < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = M - D
      M = 0
      @TRUE#{$label_counter}
      D;JLT
      #{target('vm', '1')}
      M = 1
      (TRUE#{$label_counter})
      #{target('vm', '1')}
      D = M - 1
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

class Gt < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = M - D
      M = 0
      @TRUE#{$label_counter}
      D;JGT
      #{target('vm', '1')}
      M = 1
      (TRUE#{$label_counter})
      #{target('vm', '1')}
      D = M - 1
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

class And < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = D & M\t// Bitwise and D & M
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

class Or < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      #{target('vm', '0')}
      D = M
      #{target('vm', '1')}
      D = D | M\t// Bitwise Or D | M
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

class Not < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{target('vm', '0')}
      D = M
      D = !D\t\t// Bitwise Not D
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

class Neg < Command
  def write
    out = <<-EOF
      #{Pop.new('vm', '0').write}
      #{target('vm', '0')}
      D = -M\t\t// Negate M
      #{set_stack('D')}
    EOF
    $label_counter += 1
    out
  end
end

# pop segment i
class Pop < Command
  def write
    <<-EOF
      #{get_stack}
      #{target}
      M = D\t\t// Set target to stack var
      #{decrement_sp}
    EOF
  end
end

# push segment i
class Push < Command
  def write
    out = ""
    if(@segment == 'constant')
      out << "@#{@i}\t\t// A = #{@i}\n"
      out << "D = A\t\t// D = #{@i}\n"
    elsif(@segment == 'segment')
      out << "@#{@i}\t\t// A = #{@i}\n"
      out << "D = M\t\t// D = #{@i}\n"
    else
      out << "#{target}\n"
      out << "D = M\t\t// D = #{@i}\n"
    end
    out << "#{set_stack('D')}"
  end
end

# The scope of the label is the function in which it is defined.
# The label is an arbitrary string composed of any sequence of
# letters, digits, underscore (_), dot (.), and colon (:)
# that does not begin with a digit.
class Label < Command
  def write
    <<-EOF
      (#{$current_function}$#{@segment})
    EOF
  end
end

class IfGoto < Command
  def write
    <<-EOF
      #{Pop.new('vm', '0').write}
      #{target('vm', '0')}
      D=M
      @#{@segment}
      D;JNE
    EOF
  end
end

class Goto < Command
  def write
    <<-EOF
      @#{$current_function}$#{@segment}
      0;JMP
    EOF
  end
end

class Function < Command
  def write
    $current_function = @segment
    out = ""
    out << "(#{@segment}) // I think function names are globally unique\n"
    @i.to_i.times do |j|
      out << "#{Push.new('constant', '0').write}"
    end
    out
  end
end

class Return < Command
  def write
    <<-EOF
    // frame = LCL // frame is a temp. variable
    @LCL
    D = M
    #{target('vm', '0')}
    M = D
    // retAddr = *(frame-5) // retAddr is a temp. variable
    @5
    A = D - A
    D = M
    #{target('vm', '1')}
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
    #{target('vm', '0')}
    AM = M - 1
    D = M
    @THAT
    M = D
    // THIS = *(frame-2) // restores the caller’s THIS
    #{target('vm', '0')}
    AM = M - 1
    D = M
    @THIS
    M = D
    // ARG = *(frame-3) // restores the caller’s ARG
    #{target('vm', '0')}
    AM = M - 1
    D = M
    @ARG
    M = D
    // LCL = *(frame-4) // restores the caller’s LCL
    #{target('vm', '0')}
    AM = M - 1
    D = M
    @LCL
    M = D
    // goto retAddr // goto returnAddress
    #{target('vm', '1')}
    A = M
    0;JMP
    EOF
  end
end

class Call < Command
  def write
    out = <<-EOF
      // we assume that nArgs arguments have been pushed
      // call segment numArgs
      #{Push.new('constant', "returnAddress#{$label_counter}").write}
      #{Push.new('segment', 'LCL').write}
      #{Push.new('segment', 'ARG').write}
      #{Push.new('segment', 'THIS').write}
      #{Push.new('segment', 'THAT').write}
      @#{5 + @i.to_i}
      D = A
      @SP
      D = M - D
      @#{OFFSET['argument']}
      M = D\t\t// ARG = SP-nArgs-5
      @SP
      D = M
      @LCL
      M = D\t\t// LCL = SP # repositions LCL for g
      @#{@segment}
      0;JMP
      (returnAddress#{$label_counter}) // Return
    EOF
    $label_counter += 1
    out
  end
end

# Parser
# read in from stdin or from file
# Ignore comments `//`
# detect command
# load arguments

output_file = ARGV[0].sub(/\.vm$/,'.asm')

input = ARGF.read
commands = []
$label_counter = 0
$current_function = ''

input.each_line do |line|
  #puts "Line: #{line}"

  if (line.start_with?('//'))
    next
  end

  if (line[/^\s*([-\w]+)\s*([\w\.]*)\s*(\w*)/])
    cmd = $1
    arg1 = $2
    arg2 = $3
    #puts "Cmd: #{cmd}::#{arg1}::#{arg2}"
    commands << Command.parse(cmd, arg1, arg2)
  end
end

File.open(output_file, 'w') do |fh|
  fh.puts commands.map(&:cmd_write).join("\n").gsub(/^\s+/m, "")
end
