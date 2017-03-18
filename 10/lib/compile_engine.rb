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
TERM_CLOSURES = [';', ']']

class CompileEngine
  attr_reader :doc

  def initialize(tokens, doc)
    @tokens = tokens
    @doc = doc
    @stack = [doc]
    @token_idx = 0
    @subroutine = false
    @statement = false
    @pops = []
  end

  def process!
    while @token_idx < @tokens.length
      type, token = @tokens[@token_idx]
      if type == 'keyword' && KEYWORD_LOOKUP[token]
        self.send(KEYWORD_LOOKUP[token])
      elsif type == 'symbol' && CLOSING_SYMBOLS.include?(token)
        if @statement
          @pops << @stack.pop
          @statement = false
        end
        top.add_element(type).text = token
        @pops << @stack.pop
        if @subroutine
          @pops << @stack.pop
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

  def create_statement
    return if @statement
    @stack << top.add_element('statements')
    @statement = true
  end
  # do square.dispose();
  # do square.dispose(a, b);
  def compile_do
    create_statement
    @stack << top.add_element('doStatement')
    last_token = nil
    i = 0
    while(last_token != '(')
      type, token = get_token(i)
      top.add_element(type).text = token
      i += 1
      last_token = token
    end
    i = compile_do_expression(i)
    while(last_token != ';')
      type, token = get_token(i)
      top.add_element(type).text = token
      i += 1
      last_token = token
    end
    @token_idx += i - 1
    @stack.pop
  end

  def compile_do_expression(idx)
    @stack << top.add_element('expressionList')
    i = idx
    while(get_token(i).last != ')')
      type, token = get_token(i)
      if token == ','
        top.add_element(type).text = token
      else
        @stack << top.add_element('expression')
        @stack << top.add_element('term')
        top.add_element(type).text = token
        @stack.pop
        @stack.pop
      end
      i += 1
    end
    @stack.pop
    i
  end

  # let x = y;
  # let y = square.dispose();;
  def compile_let
    create_statement
    @stack << top.add_element('letStatement')
    last_token = nil
    i = 0
    while(last_token != ';')
      if(last_token == '=')
        i = compile_expression(i,';')
      end
      if(last_token == '[')
        i = compile_expression(i,']')
      end
      type, token = get_token(i)
      top.add_element(type).text = token
      i += 1
      last_token = token
    end
    @token_idx += i - 1
    @stack.pop
  end

  def compile_expression(idx,stop_token)
    i = idx
    @stack << top.add_element('expression')
    while(get_token(i).last != stop_token)
      type, token = get_token(i)
      if(type == 'symbol')
        top.add_element(type).text = token
      else
        @stack << top.add_element('term')
        top.add_element(type).text = token
        @stack.pop
      end
      i += 1
    end
    @stack.pop
    i
  end

  def compile_return
    create_statement
    @stack << top.add_element('returnStatement')
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

  def compile_while
    create_statement
    @stack << top.add_element('whileStatement')
    top.add_element('keyword').text = 'while'
    top.add_element('symbol').text = '('
    i = compile_expression(2 , ')')
    top.add_element('symbol').text = ')'
    top.add_element('symbol').text = '{'
    @token_idx += (i + 1)
    @stack << top.add_element('statements')
  end

  def compile_if
    create_statement
    @stack << top.add_element('ifStatement')
    top.add_element('keyword').text = 'if'
    top.add_element('symbol').text = '('
    i = compile_expression(2 , ')')
    top.add_element('symbol').text = ')'
    top.add_element('symbol').text = '{'
    @token_idx += (i + 1)
    @stack << top.add_element('statements')
  end

  def compile_else
    @pops.pop # statement
    @stack << @pops.pop # if statement
    top.add_element('keyword').text = 'else'
    top.add_element('symbol').text = '{'
    @token_idx += 1
    create_statement
  end
end
