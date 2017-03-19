#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'benchmark'

Flight = Struct.new(:from, :to, :day, :price)

def parse(filename)
  start = nil
  flights = []

  File.readlines(filename).each do |line|
    if start.nil?
      start = line.chomp
      next
    end

    flights << Flight.new(*line.split(' '))
  end

  {:start => start, :flights => flights}
end

puts Benchmark.measure {
  ret = parse(ARGV[0] || '/dev/stdin')

  puts ret[:start]
  puts ret[:flights].length
}
