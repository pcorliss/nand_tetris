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
      M = M + 1 // Increment SP
    EOF
  end

  def decrement_sp
    <<-EOF
      @SP
      M = M - 1 // Decrement SP
    EOF
  end

  def set_stack(var_name)
    <<-EOF
      @SP
      A = M\t\t// Set Address to top of stack
      M = #{var_name}\t\t// RAM[SP] = #{var_name}
    EOF
  end

  def get_stack
    <<-EOF
      @SP
      A = M - 1\t\t// Set Address to top of stack minus 1
      D = M\t\t// D = RAM[SP]
    EOF
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
      #{Pop.new('temp', '0').write}
      #{Pop.new('temp', '1').write}
      @5\t\t// Temp 0
      D = M
      @6\t\t// Temp 1
      D = M + D
      #{set_stack('D')}
      #{increment_sp}
    EOF
  end
end

# pop segment i
class Pop < Command
  def write
    <<-EOF
      // #{original_command}
      #{get_stack}
      @#{@i.to_i+5} // Set target to temp #{@i}
      M = D // Set stack to temp var
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
        #{increment_sp}
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
