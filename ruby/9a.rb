#!/usr/bin/ruby

# Ignore white space and split into characters
input = File.open('9.in').read.gsub(/\s/, '').chars

out = []

# While there is input left..
while input.any?
  case input.first
  when '('
    # If it's an escape character, consume the escape seqence
    i = input.take_while{|x| x != ')'}.join
    # Extract the RLE length and times
    x, y = i.scan(/\d+/).map(&:to_i)
    # Remove escape from imput
    input = input.drop(i.size + 1)
    # Add to the output
    out <<= input.take(x) * y
    # Remove RLE from the imput
    input = input.drop(x)
  else
    # Find the non RLE content
    i = input.take_while{|x| x != '('}
    # Add to the output
    out <<= i
    # Remove from the input
    input = input.drop(i.size)
  end
end

puts out.flatten.size
