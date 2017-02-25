#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require './parser'
require './flight'

ret = Parser.parse(ARGV[0] || '/dev/stdin')

puts ret[:start]
puts ret[:flights].length
