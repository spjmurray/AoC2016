#!/usr/bin/ruby

$input = File.open('25.in').readlines.map(&:split)

def try(a)
  ip = 0

  r = {
    'a' => a,
    'b' => 0,
    'c' => 0,
    'd' => 0,
  }

  out = []

  while $input[ip]
    f = $input[ip]
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
      ip += (r.keys.include?(f[1]) ? r[f[1]] : f[1].to_i) != 0 ? (r.keys.include?(f[2]) ? r[f[2]] : f[2].to_i ) : 1
    when 'out'
      out << (r.keys.include?(f[1]) ? r[f[1]] : f[1].to_i)
      ip += 1
      if out.length == 100
        break
      end
    end
  end

  a, b = out.partition.with_index{|x, i| i % 2 == 0}
  a.all?{|x| x == 0} && b.all?{|x| x == 1}
end

0.step do |i|
  next unless try(i)
  puts i
  break
end
