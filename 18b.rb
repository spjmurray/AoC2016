#!/usr/bin/ruby

input = '......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^..'.chars
depth = 400000

class Array
  def calc
    self.reverse == self ? '.' : '^'
  end

  def safe
    self.count{|x| x == '.'}
  end
end

count = input.safe
depth.pred.times do
  input = (['.'] + input + ['.']).each_cons(3).map(&:calc)
  count += input.safe
end

puts count
