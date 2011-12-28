#!/usr/bin/env ruby
require 'yaml'
cache_file_path='/tmp/.itunes-current-track'

# Run the cache updater, so we don't have to have an item in Geek Tool for it
cache_updater = File.join(File.dirname(__FILE__), 'update_itunes_cache.rb')
`#{cache_updater}`

# This shouldn't happen but just in case
Kernel.exit 0 unless File.exists? cache_file_path
cache_file=File.open(cache_file_path, 'r') { |f| YAML.load(f.read) }


def right_align(str, amt=20)
  "%#{amt}s" % str
end

def stars_from_rating rating
  "★" * (rating.to_i/20)
end

puts cache_file[:name]
puts cache_file[:artist]
puts cache_file[:album]
