#!/usr/bin/ruby

input = File.open('7.in').readlines.map{|x| x.split(/\W/)}

class String
  def abba
    # Returns an array of 4 character palindromes with 2 unique characters
    self.chars.each_cons(4).select{|z| z==z.reverse && z.uniq.size==2}.map(&:join)
  end
end

s = input.select do |x|
  # Assume hypernets always come second (which they do)
  evens, odds = x.partition.with_index{|y,i| i.even?}
  # Look for ABBAs existing in the main address but not in hypernets
  evens.map(&:abba).flatten.any? && odds.map(&:abba).flatten.none?
end

puts s.length
