#!/usr/bin/ruby

# Split the input into pairs of extents sorted by start
input = File.open('20.in').readlines.map{|x| x.split('-').map(&:to_i)}.sort_by{|x| x.first}

# Walk the input ranges coalescing overlapping or contiguous ones
input.each_with_index do |x, i|
  loop do
    # Break if no more ranges follow this one or there is a gap between this and the next
    break unless input[i.next] && input[i.next].first <= x.last.next
    # Update the end to the largest extent and remove the entry
    x[1] = [x.last, input[i.next].last].max
    input.delete_at(i.next)
  end
end

# Caclulate the total number of addresses available
puts input.each_cons(2).map{|x, y| y.first - x.last - 1}.reduce(:+)
