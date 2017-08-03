#!/usr/bin/ruby

require 'digest'

input = 'cxdnnyjw'

index = 0

pass = Array.new(8)

while true
  # Hash each successive index
  hash = Digest::MD5.hexdigest "#{input}#{index}"
  index += 1

  # Reject invalid hashes
  next unless hash.start_with?('00000')

  # Reject invalid indices - lesson of the day to_i will return 0 for invalid input!!
  next unless ('0'..'7').to_a.include?(hash[5])

  i = hash[5].to_i

  # Reject values we have already found
  next unless pass[i].nil?

  # Accumulate the password
  pass[i] = hash[6]

  # Terminate when we have the full password
  break if pass.all?{ |x| !x.nil? }
end

puts pass.join
