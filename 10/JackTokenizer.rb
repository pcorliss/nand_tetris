#!/usr/bin/env ruby

require 'pathname'
require 'rexml/document'
require_relative 'lib/tokenizer'

path = Pathname.new(ARGV[0])

if path.file?
 output_file = ARGV[0].sub(/\.jack$/,'.xml')
 files = [ARGV[0]]
else
 output_file = "#{path}/#{path.basename}.xml"
 files = path.children.map(&:to_s).grep(/\.jack$/)
end

File.open(output_file, 'w') do |fh_out|
  doc = nil

  files.each do |file_name|
    fh = File.new(file_name)
    t = Tokenizer.new(fh)
    t.strip!
    doc = t.init_xml
    t.to_xml(doc)
  end

  #doc.write(fh_out, -1)
  s = StringIO.new
  doc.write( s, -1)
  s.rewind
  #puts s.read
  fh_out.write s.read.gsub(/></,">\n<")
end
