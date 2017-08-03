#!/usr/bin/ruby

# Convert input into an array of arrays of side lengths
input = File.open('3.in').readlines.map{|x| x.split.map(&:to_i)}

# Select the triangles whose border length less the maximum is greater than the maximum
puts input.select{|t| t.reduce(:+) - t.max > t.max}.size
