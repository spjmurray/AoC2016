#!/usr/bin/ruby

# Puzzle input
disks = [
  [ 7, 0],
  [13, 0],
  [ 3, 2],
  [ 5, 2],
  [17, 0],
  [19, 7],
]

# Stagger the disks forward in time
disks.each_with_index do |x,i|
  disks[i][1] = (disks[i].last + i + 1).modulo(disks[i].first)
end

t = 0

# Terminate when all disks line up at zero
until disks.all?{|x| x.last == 0}
  # Move the disks forward 1 second
  disks.each_with_index do |x,i|
    disks[i][1] = (disks[i].last + 1).modulo(disks[i].first)
  end
  t += 1
end

puts t
