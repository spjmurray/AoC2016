#!/usr/bin/ruby

input = File.open('7.in').readlines.map{|x| x.split(/\W/)}

class String
  def aba
    # Returns an array of 3 character palindromes with 2 unique characters
    self.chars.each_cons(3).select{|z| z==z.reverse && z.uniq.size==2}.map(&:join)
  end
  def bab
    # Maps ABAs to BABs
    self[1] + self[0] + self[1]
  end
end

s = input.select do |x|
  # Assume hypernets always come second (which they do)
  evens, odds = x.partition.with_index{|y,i| i.even?}
  # Look for any ABAs in the main address whose BAB exists in any hypernet
  (evens.map(&:aba).flatten.map(&:bab) & odds.map(&:aba).flatten).any?
end

puts s.length
