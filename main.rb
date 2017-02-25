#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'pry'
require 'pry-byebug'

require 'set'

require './parser'
require './flight'
require './greedy'


ret = Parser.parse(ARGV[0] || '/dev/stdin')

g = Greedy.new(ret)
p g.path
p g.price
