#!/usr/bin/ruby

rooms = File.open('4.in').readlines.map do |x|

  # Extract the room
  r = x.rpartition('-').first

  # Group by characters (frequency count), sort by freqency and alphabet
  c = r.gsub(/-/, '').chars.group_by(&:chr).sort_by{ |x,y| [0 - y.length, x] }

  # Return an array containing computed checksum, sector and checksum
  [ c.map(&:first)[0..4].join, r, x.scan(/\d+/).first.to_i, x.scan(/\w+/).last]

end.select{ |x| x.first == x.last }

rooms.each do |x|

  # Convert dashes to spaces and rotate characters caesar style
  plaintext = x[1].chars.map{ |y| y == '-' ? ' ' : ((y.ord - 97 + x[2]).modulo(26) + 97).chr }.join

  # Look for the north pole storage room
  next unless plaintext.include?('north')

  # Terminate when complete
  puts x[2]
  exit

end
