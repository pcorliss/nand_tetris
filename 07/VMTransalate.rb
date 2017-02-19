### Ruby shebang

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
    Object.const_get(cmd.capitalize).new(segment, i)
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
    'this' => 3,
    'that' => 4,
    'argument' => 2,
    'local' => 1,
  }

  def offset(segment = @segment)
    OFFSET[segment]
  end

  def target(segment = @segment, index = @i)
    index.to_i + offset(segment)
  end
end
# add
# sub
# neg
# eq
# gt
# lt
# and
# or
# not
#
# True == -1
# False == 0
class Add < Command
  def write
    <<-EOF
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// Temp 0
      D = M
      @#{target('vm', '1')}\t\t// Temp 1
      D = M + D
      #{set_stack('D')}
    EOF
  end
end

class Sub < Command
  def write
    <<-EOF
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// VM 0
      D = M
      @#{target('vm', '1')}\t\t// VM 1
      D = M - D
      #{set_stack('D')}
    EOF
  end
end

class Eq < Command
  def write
    out = <<-EOF
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// VM 0
      D = M
      @#{target('vm', '1')}\t\t// VM 1
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
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// VM 0
      D = M
      @#{target('vm', '1')}\t\t// VM 1
      D = M - D
      M = 0
      @TRUE#{$label_counter}
      D;JLT
      @#{target('vm', '1')}\t\t// VM 1
      M = 1
      (TRUE#{$label_counter})
      @#{target('vm', '1')}\t\t// VM 1
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
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// VM 0
      D = M
      @#{target('vm', '1')}\t\t// VM 1
      D = M - D
      M = 0
      @TRUE#{$label_counter}
      D;JGT
      @#{target('vm', '1')}\t\t// VM 1
      M = 1
      (TRUE#{$label_counter})
      @#{target('vm', '1')}\t\t// VM 1
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
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// VM 0
      D = M
      @#{target('vm', '1')}\t\t// VM 1
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
      // #{original_command}
      #{Pop.new('vm', '0').write}
      #{Pop.new('vm', '1').write}
      @#{target('vm', '0')}\t\t// VM 0
      D = M
      @#{target('vm', '1')}\t\t// VM 1
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
      // #{original_command}
      #{Pop.new('vm', '0').write}
      @#{target('vm', '0')}\t\t// VM 0
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
      // #{original_command}
      #{Pop.new('vm', '0').write}
      @#{target('vm', '0')}\t\t// VM 0
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
      // #{original_command}
      #{get_stack}
      @#{target}\t\t// Set target to #{@segment} #{@i}
      M = D\t\t// Set stack to temp var
      #{decrement_sp}
    EOF
  end
end

# push segment i
class Push < Command
  def write
    if(@segment == 'constant')
      out = <<-EOF
        // #{original_command}
        @#{@i}\t\t// A = #{@i}
        D = A\t\t// D = #{@i}
        #{set_stack('D')}
      EOF
    end
    out
  end
end


# Parser
# read in from stdin or from file
# Ignore comments `//`
# detect command
# load arguments


input = ARGF.read
commands = []
$label_counter = 0

input.each_line do |line|
  #puts "Line: #{line}"

  if(line.start_with?('//'))
     next
  end

  if(line[/^\s*(\w+)\s*(\w*)\s*(\w*)/])
    cmd = $1
    arg1 = $2
    arg2 = $3
    #puts "Cmd: #{cmd}::#{arg1}::#{arg2}"
    commands << Command.parse(cmd, arg1, arg2)
  end
end

puts commands.map(&:write).join("\n").gsub(/^\s+/m, "")
