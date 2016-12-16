#!/usr/bin/ruby

input = '10001110011110000'.chars
length = 272

def checksum(x)
  x.each_slice(2).map{|x, y| x == y ? '1' : '0'}
end

# Perform the dragon curve until we have the right length
until input.length >= length
  input += ['0'] + input.reverse.map{|x| x == '0' ? '1' : '0'}
end

# Perform 1 round of checksumming
csum = checksum(input.take(length))

# Continue until we have an odd length
until csum.length.odd?
  csum = checksum(csum)
end

puts csum.join
