#!/usr/bin/ruby

puts File.open('6.in').readlines.map(&:chars).transpose.map{|x| x.group_by(&:chr).sort_by{|a,b| b.length}.last.first}.join
