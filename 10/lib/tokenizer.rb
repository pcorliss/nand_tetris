#!/usr/bin/env ruby

require 'rexml/document'
require 'stringio'

KEYWORDS = %w(
  class constructor function method field static var int
  char boolean void true false null this let do if else while return
)
SYMBOLS = %w( { } \( \) [ ] .  , ; + - * / & | < > = ~ )

STRING_REGEX = /^"([^"\n]*)"$/ # Need to be careful about greediness
INTEGER_REGEX = /^\d+$/ # Doesn't restrict to 0 .. 32767
INTEGER_RANGE = (0..32767) # What about zero and negatives?
IDENTIFIER_REGEX = /^[a-zA-Z_][\w]*$/

class Tokenizer
  def initialize(inputfh)
    @input = inputfh
  end

  def strip!
    comment = false
    multiline_comment = false
    quote = false
    last_char = ''
    new_str = ''
    str.each_char do |char|
      last_two = last_char + char
      #puts "Char: #{char}:#{last_two}"
      if comment
        #puts "\tComment!"
        if last_two == '*/' && multiline_comment
          comment = false
          multiline_comment = false
          char = ''
        end
        if char == "\n" && !multiline_comment
          comment = false
        end
      elsif last_two == '//' && !quote
        comment = true
      elsif last_two == '/*' && !quote
        multiline_comment = true
        comment = true
      elsif !comment && char == '"'
        quote = !quote
        new_str << last_char
      else
        new_str << last_char
      end
      last_char = char
      #puts "Str: #{new_str}"
    end

    if !comment
      new_str << last_char
    end

    @str = new_str
  end

  def str
    return @str if @str
    @input.rewind
    @str = @input.read
  end

  def tokens
    return @tokens if @tokens
    token = ''
    quote = false
    @tokens = []
    str.each_char do |char|
      if !quote && char.match(/\s/)
        @tokens << token if !token.empty?
        token = ''
      elsif !quote && char == '"'
        token << char
        quote = !quote
      elsif quote && char == '"'
        token << char
        @tokens << token
        token = ''
        quote = !quote
      elsif !quote && SYMBOLS.include?(char)
        @tokens << token if !token.empty?
        @tokens << char
        token = ''
      else
        token << char
      end
    end
    @tokens << token if !token.empty?
    @tokens
  end

  def types
    tokens.map do |token|
      if SYMBOLS.include? token
        ['symbol', token]
      elsif KEYWORDS.include? token
        ['keyword', token]
      elsif token.match(IDENTIFIER_REGEX)
        ['identifier', token]
      elsif token.match(INTEGER_REGEX) && INTEGER_RANGE.include?(token.to_i)
        ['integerConstant', token]
      elsif match = token.match(STRING_REGEX)
        ['stringConstant', match[1]]
      else
        ['unknown', token]
      end
    end
  end

  def init_xml
    doc = REXML::Document.new
    doc.add_element('tokens')
    doc
  end

  def to_xml(doc = init_xml)
    tokens = doc.root
    types.each do |type, token|
      tokens.add_element(type).text = token
    end
    s = StringIO.new
    doc.write(s , -1)
    s.rewind
    s.read
  end
end
