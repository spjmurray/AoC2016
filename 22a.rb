#!/usr/bin/ruby

# From each input line extract the used and avaialable statistics
input = File.open('22.in').readlines.drop(2).map{|x| t = x.scan(/\d+/).map(&:to_i)[3..4]}

# Compare each input to each other input, counting the viable movements then accumulating
puts input.map{|x| input.count{|y| x != y && x.first != 0 && x.first <= y.last}}.reduce(:+)
