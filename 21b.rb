#!/usr/bin/ruby

input = File.open('21.in').readlines.map(&:split).reverse

output = 'fbgdceah'.chars

input.each do |i|
  case i.first
  when 'reverse'
    x = i[2].to_i
    y = i[4].to_i
    output[x..y] = output[x..y].reverse
  when 'rotate'
    if i[1] == 'based'
      x = (0...output.length).map do |y|
        shift = y + 1 + (y >= 4 ? 1 : 0)
        [(y + shift).modulo(output.length), shift]
      end.to_h[output.index(i.last)]
      output.rotate!(x)
    else
      x = i[2].to_i
      if i[1] == 'right'
        output.rotate!(x)
      else
        output.rotate!(-x)
      end
    end
  when 'swap'
    if i[1] == 'position'
      x = i[2].to_i
      y = i[5].to_i
      t = output[x]
      output[x] = output[y]
      output[y] = t
    else
      output = output.map{|x| x == i[2] ? i[5] : (x == i[5] ? i[2] : x)}
    end
  when 'move'
    x = i[2].to_i
    y = i[5].to_i
    t = output.delete_at(y)
    output = output.insert(x, t)
  end
end

puts output.join
