#!/usr/bin/env ruby

KEYWORDS = %w(
class
constructor
function
method
field
static
var
int
char
boolean
void
true
false
null
this
let
do
if
else
while
return
)

SYMBOLS = %w(
{
}
\(
\)
[
]
.
,
;
+
-
*
/
&
|
<
>
=
)

STRING_REGEX = /^"([^"\n]*)"$/ # Need to be careful about greediness
INTEGER_REGEX = /^[\-]{0,1}\d+$/ # Doesn't restrict to 0 .. 32767
INTEGER_RANGE = (-32767..32767) # What about zero and negatives?
IDENTIFIER_REGEX = /^[a-zA-Z_][\w]*$/

require 'pathname'
require 'rexml/document'


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
      if comment
        if last_two == '*/' && multiline_comment
          comment = false
          multiline_comment = false
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

describe Tokenizer do
  describe "#to_xml" do
    it "outputs expected xml" do
      input = <<-EOF
        // comment
        let i = 0;
        // ending comment
        let j = "this is string";
        getx(i<43);
        //
      EOF
      s = StringIO.new(input)
      t = Tokenizer.new(s)
      t.strip!
      xml = t.to_xml
      puts xml
      expect(xml).to_not include('comment')
      expect(xml).to_not include('//')
      expect(xml).to include("<tokens>")
      expect(xml).to include("</tokens>")
      expect(xml).to include("<symbol>=</symbol>")
      expect(xml).to include("<keyword>let</keyword>")
      expect(xml).to include("<integerConstant>0</integerConstant>")
      expect(xml).to include("<stringConstant>this is string</stringConstant>")
      expect(xml).to include("<identifier>i</identifier>")
    end
  end

  describe "#strip" do
    it "strips single line comments" do
      input = <<-EOF
        // This is a comment
        let i = 0;
        // Ending Comment
        //
      EOF
      s = StringIO.new(input)
      t = Tokenizer.new(s)
      t.strip!
      expect(t.str).to_not include('This')
      expect(t.str).to_not include('Ending')
      expect(t.str).to_not include('/')
    end

    it "strips multi line comments" do
      input = <<-EOF
        /* This is a comment
         * More
        Stuff */
        let i = 0;
        /* This is a comment
         * More
        Stuff */
      EOF
      s = StringIO.new(input)
      t = Tokenizer.new(s)
      t.strip!
      expect(t.str).to_not include('This')
      expect(t.str).to_not include('More')
      expect(t.str).to_not include('Stuff')
      expect(t.str).to_not include('*/')
      expect(t.str).to_not include('/*')
    end

    it "handles quoted comment identifiers" do
      input = <<-EOF
        let i = "// Stuff";
        let j = "/* This */";
      EOF
      s = StringIO.new(input)
      t = Tokenizer.new(s)
      t.strip!
      expect(t.str).to include('This')
      expect(t.str).to include('Stuff')
      expect(t.str).to include('*/')
      expect(t.str).to include('/*')
      expect(t.str).to include('/')
    end
  end

  describe "#tokens" do
    describe "returns an array of tokens" do
      it "handles whitespace separated elements" do
        input = "let i = 0 ;"
        s = StringIO.new(input)
        t = Tokenizer.new(s)
        tokens = t.tokens
        expected = %w(let i = 0 ;)
        expect(tokens).to eq(expected)
      end

      it "handles smooshed elements" do
        input = "getx(i<43);"
        s = StringIO.new(input)
        t = Tokenizer.new(s)
        tokens = t.tokens
        expected = %w(getx ( i < 43 ) ;)
        expect(tokens).to eq(expected)
      end

      it "handles quoted strings" do
        input = 'let length = Keyboard.readInt("NUMBER\'S? ");'
        s = StringIO.new(input)
        t = Tokenizer.new(s)
        tokens = t.tokens
        expected = %w(let length = Keyboard . readInt \() + ['"NUMBER\'S? "'] + %w(\) ;)
        expect(tokens).to eq(expected)
      end
    end
  end

  describe "#types" do
    KEYWORDS.each do |key|
      it "handles '#{key}' keyword" do
        s = StringIO.new(key)
        t = Tokenizer.new(s)
        expect(t.types.first).to eq(['keyword', key])
      end
    end

    SYMBOLS.each do |sym|
      it "handles '#{sym}' symbol" do
        s = StringIO.new(sym)
        t = Tokenizer.new(s)
        expect(t.types.first).to eq(['symbol', sym])
      end
    end

    %w(
      Foo
      bar
      bar_foo
      foo2bar
      bar2
      _foo
      reallylongstring
      re3333jjj55_3343kjj3
    ).each do |ident|
      it "handles valid identifiers '#{ident}'" do
        s = StringIO.new(ident)
        t = Tokenizer.new(s)
        expect(t.types.first).to eq(['identifier', ident])
      end
    end

    %w(
      0
      11
      222
      3333
      32767
    ).each do |ident|
      it "handles valid integer constant '#{ident}'" do
        s = StringIO.new(ident)
        t = Tokenizer.new(s)
        expect(t.types.first).to eq(['integerConstant', ident])
      end
    end

    {
      '" I am an awesome string "' => ' I am an awesome string ',
      '")"' => ')',
      '"while"' => 'while',
    }.each do |ident, expected|
      it "handles valid stringConstants: #{ident} and strips quotes" do
        s = StringIO.new(ident)
        t = Tokenizer.new(s)
        expect(t.types.first).to eq(['stringConstant', expected])
      end
    end
  end
end
