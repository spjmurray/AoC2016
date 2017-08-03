#!/usr/bin/ruby

require 'digest'

input = 'cxdnnyjw'

index = 0

pass = []

while true
  # Hash each successive index
  hash = Digest::MD5.hexdigest "#{input}#{index}"
  index += 1

  # Reject invalid hashes
  next unless hash.start_with?('00000')

  # Accumulate the password
  pass << hash[5]

  # Terminate when we have the full password
  break if pass.size == 8
end

puts pass.join
