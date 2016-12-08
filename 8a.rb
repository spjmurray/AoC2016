#!/usr/bin/ruby

screen = Array.new(6){Array.new(50, ' ')}

File.open('8.in').readlines.map(&:split).each do |f|
  case f.first
  when 'rect'
    x, y = f[1].split('x').map(&:to_i)
    (0..y-1).each{|yt| (0..x-1).each{|xt| screen[yt][xt] = '#'}}
  when 'rotate'
    xy, n = f[2].split('='); n = n.to_i; m = f[4].to_i
    screen = screen.transpose if xy == 'x'
    screen[n].rotate!(-m)
    screen = screen.transpose if xy == 'x'
  end
end

puts screen.flatten.count('#')
