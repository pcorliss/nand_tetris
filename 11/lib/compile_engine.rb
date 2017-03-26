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

SUBROUTINE_LOOKUP = {
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
  attr_reader :tokens, :class_name, :class_symbols

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

  def compile_subroutine
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

  def compile_return
  end

  def compile_while
  end

  def compile_if
  end

  def compile_else
  end

  def to_s(options = {})
    @out
  end
end
