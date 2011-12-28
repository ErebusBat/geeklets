#!/usr/bin/env ruby
require 'Date'
format = "%k:%M"
format = ARGV[0].dup if ARGV.length > 0
format.gsub!(/\\n/, "\n")
puts DateTime.now.strftime(format).strip