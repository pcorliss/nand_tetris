#!/usr/bin/env ruby

require 'rexml/document'
require 'stringio'

KEYWORD_LOOKUP = {
  'class' => 'compile_class',
  'constructor' => 'compile_subroutine',
  'function' => 'compile_subroutine',
  'method' => 'compile_subroutine',
  'field' => 'compile_class_var',
  'static' => 'compile_class_var',
  'var' => 'compile_var_dec',
  #'int' => nil,
  #'char' => nil,
  #'boolean' => nil,
  #'void' => '',
  #'true' => '',
  #'false' => '',
  #'null' => '',
  #'this' => '',
  'let' => 'compile_let',
  'do' => 'compile_do',
  'if' => 'compile_if',
  'else' => 'compile_else',
  'while' => 'compile_while',
  'return' => 'compile_return',
}

CLOSING_SYMBOLS = ['}']

class CompileEngine
  attr_reader :doc

  def initialize(tokens, doc)
    @tokens = tokens
    @doc = doc
    @stack = [doc]
    @token_idx = 0
    @subroutine = false
    @statement = false
  end

  def process!
    while @token_idx < @tokens.length
      type, token = @tokens[@token_idx]
      if type == 'keyword' && KEYWORD_LOOKUP[token]
        self.send(KEYWORD_LOOKUP[token])
      elsif type == 'symbol' && CLOSING_SYMBOLS.include?(token)
        # pop out of statement
        top.add_element(type).text = token
        @stack.pop
        if @subroutine
          @stack.pop
          @subroutine = false
        end
      end
      @token_idx += 1
    end
  end

  def top
    @stack[@stack.length - 1]
  end

  def get_token(i)
    @tokens[@token_idx + i]
  end

  # class SquareGame {
  def compile_class
    c = top.add_element('class')
    @stack << c
    top.add_element('keyword').text = 'class'
    top.add_element('identifier').text = get_token(1).last
    top.add_element('symbol').text = '{'
    @token_idx += 2
  end

  # field Square square;
  # static Square square;
  def compile_class_var
    c = top.add_element('classVarDec')
    @stack << c
    last_token = nil
    i = 0
    while(last_token != ';')
      type, token = get_token(i)
      top.add_element(type).text = token
      i += 1
      last_token = token
    end
    @token_idx += i - 1
    @stack.pop
  end

  # constructor SquareGame new() {
  # method void dispose() {
  # function void dispose() {
  def compile_subroutine
    c = top.add_element('subroutineDec')
    @stack << c
    # constructor Type new(
    top.add_element('keyword').text = get_token(0).last
    top.add_element('identifier').text = get_token(1).last
    top.add_element('identifier').text = get_token(2).last
    top.add_element('symbol').text = '('
    @token_idx += 4
    compile_parameter_list
    top.add_element('symbol').text = ')'
    @stack << top.add_element('subroutineBody')
    top.add_element('symbol').text = '{'
    @subroutine = true # need to pop twice if it's a sub-routine
    @token_idx += 2
  end

  # method void dispose(Array a, String b) {
  def compile_parameter_list
    @stack << top.add_element('parameterList')
    i = 0
    while(get_token(i).last != ')')
      type, token = get_token(i)
      top.add_element(type).text = token
      i += 1
    end
    @stack.pop
    @token_idx += i - 1
  end

  # var char key;
  def compile_var_dec
    c = top.add_element('varDec')
    @stack << c
    last_token = nil
    i = 0
    while(last_token != ';')
      type, token = get_token(i)
      top.add_element(type).text = token
      i += 1
      last_token = token
    end
    @token_idx += i - 1
    @stack.pop
  end

  # do square.dispose();
  # do square.dispose(a, b);
  def compile_do

  end

  # let x = y;
  # let y = square.dispose();;
  def compile_let

  end

  def compile_while

  end

  def compile_return

  end

  def compile_if

  end

  def compile_expression

  end
end
