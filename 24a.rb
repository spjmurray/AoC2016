#!/usr/bin/ruby

require 'red_black_tree'

$grid = File.open('24.in').readlines.map(&:chars)

# Find us (0) and each point to visit (1-N)
robot = nil
goals = []
$grid.each_with_index do |row, x|
  row.each_with_index do |c, y|
    if c == '0'
      robot = [x, y]
    elsif ('1'..'9').include?(c)
      goals[c.to_i] = c.to_i
    end
  end
end

class State
  attr_accessor :distance, :parent

  def initialize(robot, goals, distance=0)
    @robot = robot; @goals = goals; @distance = distance
  end

  def id
    @id ||= @robot.map(&:to_s).join(',') + ':' + @goals.compact.map(&:to_s).join
  end

  def <=>(o)
    id <=> o.id
  end

  def done?
    # All goals reached
    @goals.none?
  end

  def neighbours
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      # Calculate our new position
      x = @robot[0] + dx
      y = @robot[1] + dy

      # Reject walking through walls
      next if $grid[x][y] == '#'

      # Unset any goals we encounter
      goals = @goals.dup
      if $grid[x][y] != '.'
        goals[$grid[x][y].to_i] = nil
      end

      # Yield the neighbour
      yield State.new([x, y], goals, @distance + 1)
    end
  end
end

start = State.new(robot, goals)

# Main ordered priority queue for O(1) insertion and deletion
queue = [start]

# Maintain a seen set based on a binary tree for O(log(n)) searches
seen = RedBlackTree.new
seen[start] = nil

# Standard A* algorithm
while queue.any?
  # Dequeue the request
  u = queue.shift;

  # Termination condition
  break if u.done?

  # Add the node to the seen set

  # For each valid neighbour add them to the queue if not seen or enqueued already
  u.neighbours do |n|
    next if seen.key?(n)
    queue << n; seen[n] = nil
  end
end

puts u.distance
