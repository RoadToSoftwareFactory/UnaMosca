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

time = Time.now
ret = nil
  ret = Parser.parse(ARGV[0] || '/dev/stdin')

  ret[:flights] = Preprocessor.process(ret)

is_running_out = Time.now

ALGOS =[ RandomGreedy, RandomGreedy ,RandomGreedy ,RandomGreedy ,RandomGreedy ,RandomGreedy  ]

final = Greedy.new(ret)
final.run

begin
  ALGOS.each do |algo|
    g = nil
    g = algo.new(ret)
    g.run
    final = g if g.price < final.price
  end
  needed_time = (Time.now.to_f - is_running_out.to_f).to_i
  is_running_out = Time.now
end while (is_running_out.to_f - time.to_f).to_i < 30 - needed_time - 1

final.output
