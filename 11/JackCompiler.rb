#!/usr/bin/env ruby

require 'pathname'
require 'rexml/document'
require_relative 'lib/tokenizer'
require_relative 'lib/compile_engine'
require_relative 'lib/symbol_table'

path = Pathname.new(ARGV[0])

if path.file?
  files = [ARGV[0]]
else
  files = Dir.entries(path).grep(/\.jack$/).map { |f| path + f }
end

files.each do |file_name|
  fh = File.new(file_name)
  t = Tokenizer.new(fh)
  t.strip!
  ce =CompileEngine.new(t.types)
  ce.process!

  out_str = ce.to_s
  output_file = file_name.to_s.sub(/\.jack$/,'.vm')
  File.open(output_file, 'w') do |fh_out|
    fh_out.write out_str
  end
end
