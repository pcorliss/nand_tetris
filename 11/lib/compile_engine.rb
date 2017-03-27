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
EXPR_SYMBOLS = [
  ['(', ')'],
  ['[', ']'],
]

OP_LOOKUP = {
  '+' => 'add',
  '-' => 'sub',
  '*' => 'call Math.multiply 2',
  '/' => 'call Math.divide 2',
  '&' => 'and',
  '|' => 'or',
  '<' => 'lt',
  '>' => 'gt',
  '=' => 'eq',
}

UNARY_OP_LOOKUP = {
  '~' => 'not',
  '-' => 'neg',
}

class CompileEngine
  attr_reader :tokens, :class_name, :class_symbols, :sub_symbols, :function_name, :return_type

  def initialize(tokens)
    @tokens = tokens
    @lines = []
    @class_symbols = SymbolTable.new
    @var_count = {}
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

  def compile_var(idx, symbol_table)
    i = idx
    _, var_kind = get_token(i)
    i += 1
    _, var_type = get_token(i)
    i += 1
    while(get_token(i).last != ';') do
      _, token = get_token(i)
      symbol_table.set(token, var_type, var_kind) if(token != ',')
      i += 1
    end
    i
  end

  def compile_class_var(idx)
    compile_var(idx, class_symbols)
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

    # Need to look ahead for var dec, using a block set at output time
    write(lambda { "function #{class_name}.#{function_name} #{@var_count[function_name]}" })
    if @sub_type == 'method'
      write "push argument 0"
      write "pop pointer 0"
    end

    #put_status(i, "compile_class #{@class_name}: ")
    i = evaluate_until('}', SUB_LOOKUP, i) # class blah {

    @var_count[function_name] = @sub_symbols.count('var')
    i
  end

  def compile_parameter_list
  end

  def compile_var_dec(idx)
    compile_var(idx, sub_symbols)
  end

  def compile_do
  end

  def compile_expression_list
  end

  def compile_let
  end

  def lookup_symbol(var)
    sub_symbols.get(var) || class_symbols.get(var)
  end

  def write_element(element)
    if element.first == 'integerConstant'
      "constant #{element.last}"
    elsif element.first == 'keyword'
      'foo bar'
    else
      lookup_symbol(element.last).write_symbol
    end
  end

  def compile_expression(idx, end_token)
    i = idx
    elements = []
    while(get_token(i).last != end_token) do
      elements << get_token(i)
      i += 1
    end

    if elements.length == 1
      write "push #{write_element(elements[0])}"
    elsif elements.length == 3
      write "push #{write_element(elements[0])}"
      write "push #{write_element(elements[2])}"
      write "#{OP_LOOKUP[elements[1].last]}"
    elsif elements.length == 2
      write "push #{write_element(elements[1])}"
      write "#{UNARY_OP_LOOKUP[elements[0].last]}"
    end

    i
  end

  def compile_return(idx)
    i = idx
    #_, _ = get_token(i) # return
    i += 1
    if get_token(i).last == ';'
      write "push constant 0"
    else
      i = compile_expression(i, ';')
    end
    write "return"
    #_, _ = get_token(i) # ;
    i += 1
  end

  def compile_while
  end

  def compile_if
  end

  def compile_else
  end

  def write(element)
    @lines << element
  end

  def to_s(options = {})
    out = @lines.map do |line|
      str = line
      str = line.call if line.is_a? Proc
      str
    end.join("\n")
    out << "\n" unless out.empty?
    out
  end
end
