#!/usr/bin/env ruby

require 'pathname'
require 'rexml/document'
require_relative 'lib/tokenizer'
require_relative 'lib/compile_engine'

path = Pathname.new(ARGV[0])

if path.file?
 output_file = ARGV[0].sub(/\.jack$/,'Mine.xml')
 files = [ARGV[0]]
else
  raise "Doesn't handle directories yet"
end

File.open(output_file, 'w') do |fh_out|
  #doc = nil
  xml_str = ''
  files.each do |file_name|
    fh = File.new(file_name)
    t = Tokenizer.new(fh)
    t.strip!
    ce =CompileEngine.new(t.types, REXML::Document.new)
    ce.process!

    xml_str = ce.to_s(strip_whitespace: true, newlines: true, fix_empty: true)
  end

  #doc.write(fh_out, -1)
  #s = StringIO.new
  #doc.write( s, -1)
  #s.rewind
  #puts s.read
  fh_out.write xml_str
end
