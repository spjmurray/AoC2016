#!/usr/bin/ruby

require 'digest'

$input = 'bwnlcvfs'

class State
  attr_accessor :x, :y, :path

  def initialize(x, y, path)
    @x = x; @y = y; @path = path
  end

  def done
    @x == 3 && @y == 3
  end

  def neighbours
    hash = Digest::MD5.hexdigest($input + @path)
    [[0, -1, 'U', 0], [0, 1, 'D', 1], [-1, 0, 'L', 2], [1, 0, 'R', 3]].each do |i|
      if (0..3).include?(@x+i[0]) && (0..3).include?(@y+i[1])&& ('b'..'f').include?(hash[i[3]])
        yield State.new(@x+i[0], @y+i[1], @path + i[2])
      end
    end
  end
end


queue = [State.new(0, 0, '')]

while queue.any?
  u = queue.shift
  next longest = u if u.done
  u.neighbours{|n| queue << n}
end

puts longest.path.length
