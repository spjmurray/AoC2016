#!/usr/bin/ruby

input = File.open('12.in').readlines

ip = 0

r = {
  'a' => 0,
  'b' => 0,
  'c' => 0,
  'd' => 0,
}

while input[ip]
  f = input[ip].split
  case f.first
  when 'cpy'
    r[f[2]] = r.keys.include?(f[1]) ? r[f[1]] : f[1].to_i
    ip += 1
  when 'inc'
    r[f[1]] += 1
    ip += 1
  when 'dec'
    r[f[1]] -= 1
    ip += 1
  when 'jnz'
    ip += (r.keys.include?(f[1]) ? r[f[1]] : f[1].to_i) != 0 ? f[2].to_i : 1
  end
end

puts r
