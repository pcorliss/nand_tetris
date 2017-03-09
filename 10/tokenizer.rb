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
_
)

STRING_REGEX = /^"([^"\n]*)"$/ # Need to be careful about greediness
INTEGER_REGEX = /^\d+$/ # Doesn't restrict to 0 .. 32767
INTEGER_RANGE = (1..32767) # What about zero and negatives?
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

path = Pathname.new(ARGV[0])


if path.file?
  output_file = ARGV[0].sub(/\.jack$/,'.xml')
  files = [ARGV[0]]
else
  output_file = "#{path}/#{path.basename}.xml"
  files = path.children.map(&:to_s).grep(/\.jack$/)
end

#File.open(output_file, 'w') do |fh_out|
  doc = REXML::Document.new
  tokens = doc.add_element('tokens')
  #tokens.add_element('keyword').text = ' ' + 'foo' + ' '
  files.each do |file_name|
    fh = File.new(file_name)
    comment = false
    multiline_comment = false
    last_char = ''
    working_token = ''
    fh.each_char do |char|
      #puts "\tChar: #{char} ----- #{working_token}"
      last_two = last_char + char
      if comment
        if last_two == '*/' && multiline_comment
          comment = false
          multiline_comment = false
        end
        if char == "\n" && !multiline_comment
          comment = false
        end
      elsif last_two == '//'
        comment = true
        working_token = ''
      elsif last_two == '/*'
        multiline_comment = true
        comment = true
        working_token = ''
      elsif char.match(/\s/)
        if !working_token.empty?
          if tag_name(working_token) != 'stringConstant'
            tokens.add_element(tag_name(working_token)).text = working_token
            #puts "\t\t#{tag_name(working_token)}::#{working_token}"
            working_token = ''
          else
            working_token << char
          end
        end
      elsif tag_name(char) == 'symbol' && !working_token.empty?
        if tag_name(working_token) == 'stringConstant'
          working_token = trim_quotes(working_token)
        end
        tokens.add_element(tag_name(working_token)).text = working_token
        #puts "\t\t#{tag_name(working_token)}::#{working_token}"
        working_token = ''
        tokens.add_element('symbol').text = char
        #puts "\t\tsymbol::#{char}"
      else
        working_token << char
      end
      last_char = char
    end
  end
  require 'stringio'
  s = StringIO.new
  doc.write( s, -1)
  s.rewind
  #puts s.read
  puts s.read.gsub(/></,">\n<")
#end


