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

def tag_name(token)
  if KEYWORDS.include?(token)
    'keyword'
  elsif SYMBOLS.include?(token)
    'symbol'
  elsif token.match(IDENTIFIER_REGEX)
    'identifier'
  elsif token.match(INTEGER_REGEX) && INTEGER_RANGE.include?(token.to_i)
    'integerConstant'
  else
    'stringConstant'
  end
end

def trim_quotes(token)
  token[1..(token.length-2)]
end

#path = Pathname.new(ARGV[0])


#if path.file?
  #output_file = ARGV[0].sub(/\.jack$/,'.xml')
  #files = [ARGV[0]]
#else
  #output_file = "#{path}/#{path.basename}.xml"
  #files = path.children.map(&:to_s).grep(/\.jack$/)
#end

#File.open(output_file, 'w') do |fh_out|
  #doc = REXML::Document.new
  #tokens = doc.add_element('tokens')
  ##tokens.add_element('keyword').text = ' ' + 'foo' + ' '
  ##
  ## getx() -> three params
  ## // foo \n
  ## bar -> one token
  ## /* multiline
  ## */
  ##
  #files.each do |file_name|
    #fh = File.new(file_name)
    #comment = false
    #multiline_comment = false
    #last_char = ''
    #working_token = ''
    #fh.each_char do |char|
      ##puts "\tChar: #{char} ----- #{working_token}"
      #last_two = last_char + char
      #if comment
        #if last_two == '*/' && multiline_comment
          #comment = false
          #multiline_comment = false
        #end
        #if char == "\n" && !multiline_comment
          #comment = false
        #end
      #elsif last_two == '//'
        #comment = true
        #working_token = ''
      #elsif last_two == '/*'
        #multiline_comment = true
        #comment = true
        #working_token = ''
      #elsif char.match(/\s/)
        #if !working_token.empty?
          #if tag_name(working_token) != 'stringConstant'
            #tokens.add_element(tag_name(working_token)).text = working_token
            ##puts "\t\t#{tag_name(working_token)}::#{working_token}"
            #working_token = ''
          #else
            #working_token << char
          #end
        #end
      #elsif tag_name(char) == 'symbol' && !working_token.empty?
        #if tag_name(working_token) == 'stringConstant'
          #working_token = trim_quotes(working_token)
        #end
        #tokens.add_element(tag_name(working_token)).text = working_token
        ##puts "\t\t#{tag_name(working_token)}::#{working_token}"
        #working_token = ''
        #tokens.add_element('symbol').text = char
        ##puts "\t\tsymbol::#{char}"
      #else
        #working_token << char
      #end
      #last_char = char
    #end
  #end
  #require 'stringio'
  #s = StringIO.new
  #doc.write( s, -1)
  #s.rewind
  ##puts s.read
  #puts s.read.gsub(/></,">\n<")
#end

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
      end
    end
  end
end

describe Tokenizer do
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
