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

STRING_REGEX = /"([^"\n]*)"/ # Need to be careful about greediness
INTEGER_REGEX = /\d+/ # Doesn't restrict to 0 .. 32767
INTEGER_RANGE = (1..32767) # What about zero and negatives?
IDENTIFIER_REGEX = /[a-zA-Z_][\w]*/

require 'pathname'
require 'rexml/document'

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
    slash_count = 0
    fh.each_char do |char|
      if char == '/'
        slash_count += 1
        if slash_count > 1
          comment = true
        end
      else
        slash_count = 0
      end


    end
  end
  require 'stringio'
  s = StringIO.new
  doc.write( s, -1)
  s.rewind
  puts s.read.gsub(/></,">\n<")
#end


