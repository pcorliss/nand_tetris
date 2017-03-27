#!/usr/bin/env ruby

require 'symbol_table'

  #'int' => nil,
  #'char' => nil,
  #'boolean' => nil,
  #'void' => '',
  #'true' => '',
  #'false' => '',
  #'null' => '',
  #'this' => '',

BASE_LOOKUP = {
  'class' => 'compile_class',
}

CLASS_LOOKUP = {
  'field' => 'compile_class_var',
  'static' => 'compile_class_var',
  'constructor' => 'compile_subroutine',
  'function' => 'compile_subroutine',
  'method' => 'compile_subroutine',
}

SUB_LOOKUP = {
  'var' => 'compile_var_dec',
  'let' => 'compile_let',
  'do' => 'compile_do',
  'if' => 'compile_if',
  'else' => 'compile_else',
  'while' => 'compile_while',
  'return' => 'compile_return',
}

TERM_CLOSURES = [';', ']']
OP = ['+', '-', '*', '/', '&', '|', '<', '>', '=']
UNARY = ['-', '~']
OP_UNARY = OP + UNARY
OP_UNARY_PARAN = OP_UNARY + ['(', ')', ',']
CLOSING_SYMBOLS = ['}']

class CompileEngine
  attr_reader :tokens, :class_name, :class_symbols, :sub_symbols, :function_name, :return_type

  def initialize(tokens)
    @tokens = tokens
    @out = ''
    @class_symbols = SymbolTable.new
  end

  def process!
    evaluate_until(nil, BASE_LOOKUP, 0)
  end

  def evaluate_until(end_token, keywords, idx)
    i = idx
    type, token = get_token(i)
    while(token != end_token) do
      if type == 'keyword' && keywords[token]
        i = self.send(keywords[token], i) - 1
      end
      i += 1
      type, token = get_token(i)
    end
    i
  end

  def get_token(i)
    @tokens[i]
  end

  def compile_class(idx)
    i = idx
    _, @class_name = get_token(i+1)
    #put_status(i, "compile_class #{@class_name}: ")
    i = evaluate_until('}', CLASS_LOOKUP, i+2) # class blah {
    i
  end

  def put_status(i, prefix = '')
    puts "#{prefix} Tokens: #{get_token(i-1)} #{get_token(i)} #{get_token(i+1)}"
  end

  def compile_class_var(idx)
    i = idx
    _, var_kind = get_token(i)
    i += 1
    _, var_type = get_token(i)
    i += 1
    while(get_token(i).last != ';') do
      _, token = get_token(i)
      class_symbols.set(token, var_type, var_kind) if(token != ',')
      i += 1
    end
    i
  end

  # function void main() {}
  # constructor int main(int arg1) {}
  # method int main(Array arg1, String arg2) {}
  def compile_subroutine(idx)
    @sub_symbols = SymbolTable.new
    i = idx
    _, @sub_type = get_token(i)
    i += 1
    _, @return_type = get_token(i)
    i += 1
    _, @function_name = get_token(i)
    i += 1
    _, _ = get_token(i) # opening paran
    i += 1


    @sub_symbols.set('this', @class_name, 'arg') if @sub_type == 'method'

    while(get_token(i).last != ')') do
      i += 1 if get_token(i).last == ','

      _, arg_type = get_token(i)
      i += 1
      _, arg_name = get_token(i)
      i += 1

      @sub_symbols.set(arg_name, arg_type, 'arg')
    end

    # Need to look ahead for var dec
    # Could do something fancy with blocks
    write "function #{class_name}.#{function_name} 0"
    if @sub_type == 'method'
      write "push argument 0"
      write "pop pointer 0"
    end

    #put_status(i, "compile_class #{@class_name}: ")
    i = evaluate_until('}', SUB_LOOKUP, i) # class blah {
    i
  end

  def compile_parameter_list
  end

  def compile_var_dec
  end

  def compile_do
  end

  def compile_expression_list
  end

  def compile_let
  end

  def compile_expression(idx,stop_token)
  end

  def compile_return(idx)
    i = idx
    #_, _ = get_token(i) # return
    i += 1
    # handle expression
    #_, _ = get_token(i) # ;
    write "push constant 0"
    write "return"
    i += 1
  end

  def compile_while
  end

  def compile_if
  end

  def compile_else
  end

  def write(str)
    @out << str + "\n"
  end

  def to_s(options = {})
    @out
  end
end
