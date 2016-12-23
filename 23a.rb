#!/usr/bin/ruby

input = File.open('23.in').readlines.map(&:split)

ip = 0

r = {
  'a' => 7,
  'b' => 0,
  'c' => 0,
  'd' => 0,
}

while input[ip]
  f = input[ip]
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
  when 'tgl'
    t = ip + r[f[1]]
    if input[t]
      if input[t].length == 2
        input[t][0] = input[t].first == 'inc' ? 'dec' : 'inc'
      else
        if input[t].first == 'jnz'
          if r.keys.include?(input[t][2])
            input[t][0] = 'cpy'
          end
        else
          input[t][0] = 'jnz'
        end
      end
    end
    ip += 1
  end
end

puts r
