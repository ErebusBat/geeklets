#!/usr/bin/env ruby
require 'date'
require 'time'
fmt = '%b-%d %H:%M'
puts "Now: #{Time.now.strftime(fmt)}"
puts "UTC: #{Time.now.utc.strftime(fmt)}"