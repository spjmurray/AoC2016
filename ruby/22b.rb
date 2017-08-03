#!/usr/bin/ruby

require 'red_black_tree'

# Extract all integer data
input = File.open('22.in').readlines.drop(2).map{|x| x.scan(/\d+/).map(&:to_i)}

# Find the empty node
empty = input.find{|x| x[3] == 0}

# Create an x,y grid to indicate whether the node is viable to move
# e.g. the data on this drive can be moved anywhere else in the grid
$grid = []
input.each do |i|
  x, y = i.take(2)
  $grid[x] ||= []
  $grid[x][y] = input.reject{|j| j == i}.all?{|j| j[2] >= i[3]}
end

# Model our empty and goal nodes as vectors
class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x; @y = y
  end

  def +(other)
    Vector.new(x + other.x, y + other.y)
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def manhattan_distance(other)
    (x - other.x).abs + (y - other.y).abs
  end

  def to_s
    x.to_s + ',' + y.to_s
  end
end

# Model unique states as a pair of vectors representing the empty
# node and the goal node
class Node
  attr_accessor :distance

  def initialize(empty, goal, distance=0)
    @empty = empty
    @goal = goal
    @distance = distance
  end

  # Unique state ID, should be comparable as quickly as possible
  def id
    @id ||= @empty.to_s + ':' + @goal.to_s
  end

  def <=>(o)
    id <=> o.id
  end

  def done?
    @goal == Vector.new(0, 0)
  end

  def neighbours
    # Any node horizontally or vertically adjacent the empty node may be moved
    [Vector.new(1, 0), Vector.new(-1, 0), Vector.new(0, 1), Vector.new(0, -1)].each do |d|
      # Create a target node to potentially move
      empty = @empty + d

      # Reject out of bounds indices
      next unless (0...$grid.length).include?(empty.x) && (0...$grid.first.length).include?(empty.y)

      # Reject moving full nodes
      next unless $grid[empty.x][empty.y]

      # Optimisation - initially we let the empty node find the goal node
      # naturally.  When the goal node is moved the empty node is free to
      # explore the entire grid again, which is slow.  We want the empty
      # node to drag the goal node towards our exit coordinate.  Simply put
      # once they are within a mahattan distance of 2 don't let them separate
      # any further
      next if @empty.manhattan_distance(@goal) <= 2 && empty.manhattan_distance(@goal) > 2

      # Update the goal if we are moving it
      goal = @goal == empty ? @empty : @goal
      
      # Yield the new node
      yield Node.new(empty, goal, @distance+1)
    end
  end
end

# Create the empty vector
empty = Vector.new(empty[0], empty[1])

# And the goal vector
goal = Vector.new($grid.length-1, 0)

# Create the initial state
start = Node.new(empty, goal)

# Main ordered priority queue for O(1) insertion and deletion
queue = [start]

# Maintain a seen set based on a binary tree for O(log(n)) searches
seen = RedBlackTree.new
seen[start] = nil

# Standard A* algorithm
while queue.any?
  # Dequeue the request
  u = queue.shift

  # Termination condition
  break if u.done?

  # For each valid neighbour add them to the queue if not seen or enqueued already
  u.neighbours do |n|
    next if seen.key?(n)
    queue << n;
    seen[n] = nil
  end
end

puts u.distance
