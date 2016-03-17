def truth_table(&block)
  (0..1).each do |x|
    (0..1).each do |y|
      print "#{x} "
      print "#{y} "
      num = block.call(x == 1, y == 1) ? 1 : 0
      print num
      print "\n"
    end
  end
end

truth_table do |x, y|
  !(x && y)
  x ^ y
end
