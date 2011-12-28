#!/usr/bin/env ruby
require 'yaml'
cache_file_path='/tmp/.itunes-current-track'
Kernel.exit 0 unless File.exists? cache_file_path
cache_file=File.open(cache_file_path, 'r') { |f| YAML.load(f.read) }


def stars_from_rating rating
  "★" * rating
  #"☆" * rating
end

puts stars_from_rating(cache_file[:stars])
