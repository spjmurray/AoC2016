#!/usr/bin/ruby

require 'matrix'

input = 'R4, R5, L5, L5, L3, R2, R1, R1, L5, R5, R2, L1, L3, L4, R3, L1, L1, R2, R3, R3, R1, L3, L5, R3, R1, L1, R1, R2, L1, L4, L5, R4, R2, L192, R5, L2, R53, R1, L5, R73, R5, L5, R186, L3, L2, R1, R3, L3, L3, R1, L4, L2, R3, L5, R4, R3, R1, L1, R5, R2, R1, R1, R1, R3, R2, L1, R5, R1, L5, R2, L2, L4, R3, L1, R4, L5, R4, R3, L5, L3, R4, R2, L5, L5, R2, R3, R5, R4, R2, R1, L1, L5, L2, L3, L4, L5, L4, L5, L1, R3, R4, R5, R3, L5, L4, L3, L1, L4, R2, R5, R5, R4, L2, L4, R3, R1, L2, R5, L5, R1, R1, L1, L5, L5, L2, L1, R5, R2, L4, L1, R4, R3, L3, R1, R5, L1, L4, R2, L3, R5, R3, R1, L3'

input = input.split(', ')

# We can head in 4 different directions N (0, +1), E(+1, 0), S(0, -1), W(-1, 0)
# Turning right, increments the index, turning left decrements it.  Index is (mod 4)
dirs = [Vector[0, 1], Vector[1, 0], Vector[0, -1], Vector[-1, 0]]

pos = Vector[0, 0]

index = 0

input.each do |i|

  # Determine the direction and normalise the index
  index = (index + (i[0] == 'R' ? 1 : -1)).modulo(4)

  # Determine the magnitude of our movement
  magnitude = i[1..-1].to_i

  # Move
  pos += dirs[index] * magnitude

end

puts pos.map(&:abs).reduce(:+)
