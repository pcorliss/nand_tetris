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
OP = ['+', '-', '*', '/', '&', '|', '<', '>', '=']
UNARY = ['-', '~']
OP_UNARY = OP + UNARY
OP_UNARY_PARAN = OP_UNARY + ['(', ')', ',']

class CompileEngine
  def initialize(tokens)
    @tokens = tokens
    @token_idx = 0
  end

  def process!
    #while @token_idx < @tokens.length
      #type, token = @tokens[@token_idx]
      #if type == 'keyword' && KEYWORD_LOOKUP[token]
        #self.send(KEYWORD_LOOKUP[token])
      #elsif type == 'symbol' && CLOSING_SYMBOLS.include?(token)
        #if in_statement?
          #@pops << @stack.pop
          #@statement = false
        #end
        #top.add_element(type).text = token
        #@pops << @stack.pop

        #if @pops.last.name == 'subroutineBody'
          #@pops << @stack.pop
          #@subroutine = false
        #end
      #end
      #@token_idx += 1
    #end
  end

  def get_token(i)
    @tokens[@token_idx + i]
  end

  def compile_class
    c = top.add_element('class')
    @stack << c
    top.add_element('keyword').text = 'class'
    top.add_element('identifier').text = get_token(1).last
    top.add_element('symbol').text = '{'
    @token_idx += 2
  end

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

  def compile_subroutine
    c = top.add_element('subroutineDec')
    @stack << c
    top.add_element('keyword').text = get_token(0).last
    top.add_element(get_token(1).first).text = get_token(1).last
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

  def in_statement?
    top.name == 'statements'
  end

  def create_statement
    return if in_statement?
    @stack << top.add_element('statements')
  end

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
        i = compile_expression(i, [',', ')']) - 1
      end
      i += 1
    end
    @stack.pop
    i
  end

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

  def in_term?
    top.name == 'term'
  end

  def compile_expression(idx,stop_token)
    if stop_token.is_a? String
      stop_token = [stop_token]
    end

    i = idx
    @stack << top.add_element('expression')
    @stack << top.add_element('term')

    while(!stop_token.include?(get_token(i).last))
      put_status "While #{i} #{get_token(i)}:"
      type, token = get_token(i)
      previous = get_token(i - 1)
      if token == '(' && (!OP_UNARY_PARAN.include?(previous.last))  # And empty or commas ? or maybe something else
        top.add_element(type).text = token
        i = compile_do_expression(i + 1) - 1
      elsif token == '(' # Can it handled nested parans?
        top.add_element(type).text = token
        i = compile_expression(i + 1, ')')
        top.add_element(type).text = ')'
      elsif(token == '[')
        top.add_element(type).text = token
        i = compile_expression(i + 1, ']') - 1
      elsif type == 'symbol' && OP_UNARY.include?(token)
        if (i == idx)
          top.add_element(type).text = token
          @stack << top.add_element('term')
        else
          @stack.pop
          top.add_element(type).text = token
          @stack << top.add_element('term')
        end
      else
        top.add_element(type).text = token
      end
      i += 1
    end

    until !in_term? do
      @stack.pop
    end
    @stack.pop
    i
  end

  def put_status(prefix = "")
    #puts "#{prefix} Current Token: #{get_token(0).inspect}"
    #puts "#{prefix} Current Stack: #{top.inspect}"
    #puts "#{prefix} Current Tokens: #{@token_idx} #{@tokens[@token_idx - 1..@token_idx + 1].map(&:last).inspect}"
  end

  def compile_return
    put_status("PreCreateStatement:")
    create_statement
    put_status("PostCreateStatement:")
    @stack << top.add_element('returnStatement')
    top.add_element('keyword').text = 'return'
    i = 1
    i = compile_expression(1 , ';') if get_token(1).last != ';'
    top.add_element('symbol').text = ';'
    @token_idx += i
    put_status("PreReturnPop")
    @stack.pop
    put_status("PostReturnPop")
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
    @stack << @pops.pop # if statement
    top.add_element('keyword').text = 'else'
    top.add_element('symbol').text = '{'
    @token_idx += 1
    create_statement
  end

  def to_s(options = {})
  end
end
