#!/usr/bin/ruby

$input = 1358

# Valid coordinates to moves to follow a simple calculation added
# to the puzzle input.  It is then convered to binary, if this value
# contains an even number of 1s then the move is valid
def valid(x, y)
  return false if x < 0 || y < 0
  i = x*x + 3*x + 2*x*y + y + y*y + $input
  i.to_s(2).chars.count{|z| z == '1'}.even?
end

# States contain a node and a distance
class State
  attr_accessor :x, :y, :distance

  def initialize(x, y, distance)
    @x = x
    @y = y
    @distance = distance
  end

  # The node is a unique state within the system e.g. x,y coordinate
  def node
    [@x, @y]
  end

  # Move the specified amount and return a new object
  def move(x, y)
    State.new(@x + x, @y + y, @distance + 1)
  end
end

# Standard dykstra breadth-first search, shortest distances are
# evaluated from the front of the queue, new longer dinstances
# are added to the back
queue = []
queue <<= State.new(1, 1, 0)

# Remember where we have been to avoid repeating work
seen = []

while queue.any?
  u = queue.shift

  # Termination condition and puzzle output
  break if u.distance > 50

  # Check if we have seen this state yet and ignore if we have
  next if seen.include?(u.node)
  seen <<= u.node

  # Queue up movements if valid
  queue <<= u.move(-1,  0) if valid(u.x-1, u.y  )
  queue <<= u.move( 1,  0) if valid(u.x+1, u.y  )
  queue <<= u.move( 0, -1) if valid(u.x,   u.y-1)
  queue <<= u.move( 0,  1) if valid(u.x,   u.y+1)
end

puts seen.length
