def nand(x, y)
  !(x && y)
end

def truth_table(&block)
  print "x y o\n"
  (0..1).each do |x|
    (0..1).each do |y|
      print "#{x} "
      print "#{y} "
      num = block.call(x == 1, y == 1) ? 1 : 0
      print num
      print "\n"
    end
  end
  puts ""
end

puts "x NAND x"
truth_table do |x, y|
  nand(x, y)
end

puts "! x"
truth_table do |x, y|
  !x
end
