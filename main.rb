#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'pry'
require 'pry-byebug'
require 'benchmark'

require 'set'

require './parser'
require './preprocessor'
require './flight'
require './algo'
require './greedy'
require './random_greedy'


ret = Parser.parse(ARGV[0] || '/dev/stdin')
ret[:flights] = Preprocessor.process(ret)


ALGOS = [ Greedy, RandomGreedy, RandomGreedy ,RandomGreedy ,RandomGreedy ,RandomGreedy ,RandomGreedy  ]

ALGOS.each do |algo|
  g = nil

  measure = Benchmark.measure {
    g = algo.new(ret)
    g.run
  }

  $stderr.puts "#{algo}: price = #{g.price}; time = #{measure.total}"
  g.output

  puts
end
