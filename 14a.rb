#!/usr/bin/ruby

require 'digest'

# Puzzle input
input = 'ngcjuoqr'

# Our hasher has a built in cache as due to the algorithmic complexity
# we may need to compute each index 1001 times
class Hash
  def initialize(salt)
    @salt = salt
    @cache = {}
  end

  def hash(index)
    @cache[index] ||= Digest::MD5.hexdigest(@salt + index.to_s)
  end
end

# Initialize our hasher
hash = Hash.new(input)

# Current index
i = -1

# Ordered list of keys we have found
keys = []

# Collect 64 keys
until keys.length == 64
  # Pre-increment the counter
  i += 1

  # Hash the index and find the first group of 3 consecutive same characters
  h = hash.hash(i)
  group = h.chars.each_cons(3).find{|x| x.uniq.length == 1}
  next unless group

  # If we have a group of 3 add the key if the next 1000 hashes feature a run
  # of 5 of the same character
  keys <<= h if (1..1000).find{|x| hash.hash(i+x).include?(group.first * 5)}
end

# Puzzle output
puts i
