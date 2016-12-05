#!/usr/bin/ruby

rooms = File.open('4.in').readlines.map do |x|

  # Extract the room
  r = x.rpartition('-').first

  # Group by characters (frequency count), sort by freqency and alphabet
  c = r.gsub(/-/, '').chars.group_by(&:chr).sort_by{ |x,y| [0 - y.length, x] }

  # Return an array containing computed checksum, sector and checksum
  [ c.map(&:first)[0..4].join, x.scan(/\d+/).first.to_i, x.scan(/\w+/).last]

end.select{ |x| x.first == x.last }

puts rooms.map{ |x| x[1] }.reduce(:+)
