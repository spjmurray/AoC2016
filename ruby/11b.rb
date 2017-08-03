#!/usr/bin/ruby

require 'red_black_tree'

class State
  attr_accessor :floor, :elements, :distance

  def initialize(floor, elements, distance)
    @floor = floor
    @elements = elements
    @distance = distance
  end

  # Return the unique state of the system
  # A node is unique if the relative positions of generator/chip pairs regardless of name
  # We also we get a huge performance gain by compressing into the smallest possible state
  def id
    @id ||= (@floor.to_s + @elements.values.sort_by{|x, y| [x, y]}.flatten.join).to_i
  end

  def <=>(o)
    id <=> o.id
  end

  def done
    @elements.values.flatten.all?{|x| x == 3}
  end

  def neighbours
    # Get all generators and chips on the floor, remembering the element and index
    g = @elements.select{|x, y| y.first == @floor}.map{|x, y| [x, 0]}
    c = @elements.select{|x, y| y.last  == @floor}.map{|x, y| [x, 1]}

    # Calculate all unique permutations
    p = g.permutation(1).to_a + c.permutation(1).to_a + (g + c).permutation(2).to_a.map{|x| x.sort_by{|i| [i.first, i.last]}}.uniq

    # Going up or down a floor...
    [1, -1].each do |i|
      # Reject floor out of bounds
      next unless (0..3).include?(@floor + i)
      # For each permutation
      p.each do |p|
        # Deep copy the elements
        elements = @elements.map{|x, y| [x, y.dup]}.to_h
        # Move each element in the permutation by the desired amount
        p.each{|x| elements[x.first][x.last] += i}
        # Reject unless all elements chips are with their generator or there are no other generators on the floor
        next unless elements.all?{|x| x.last.first == x.last.last || elements.none?{|_, j| j.first == x.last.last}}
        # Yield a new state
        yield State.new(@floor + i, elements, @distance + 1)
      end
    end
  end
end

# Puzzle input
elements = {
  :thulium    => [0, 0],
  :plutonium  => [0, 1],
  :strontium  => [0, 1],
  :promethium => [2, 2],
  :ruthenium  => [2, 2],
  :elerium    => [0, 0],
  :dilithium  => [0, 0],
}

start = State.new(0, elements, 0)

# Main ordered priority queue for O(1) insertion and deletion
queue = [start]

# Maintain a ready set based on a binary tree for O(log(n)) searches
ready = RedBlackTree.new
ready[start] = nil

# Maintain a seen set based on a binary tree for O(log(n)) searches
seen = RedBlackTree.new

# Standard A* algorithm
while queue.any?
  # Dequeue the request
  u = queue.shift; ready.delete(u)

  # Termination condition
  break if u.done

  # Add the node to the seen set
  seen[u] = nil

  # For each valid neighbour add them to the queue if not seen or enqueued already
  u.neighbours do |n|
    next if ready.key?(n) || seen.key?(n)
    queue << n; ready[n] = nil
  end
end

puts u.distance
