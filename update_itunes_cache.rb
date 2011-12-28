#!/usr/bin/env ruby
require 'yaml'
cache_file_path='/tmp/.itunes-current-track'
cache_file=File.open(cache_file_path, 'r') { |f| YAML.load(f.read) } if File.exists? cache_file_path

def update_album_artwork
  artwork_script=File.join(File.dirname(__FILE__), 'tools/iTunesArtwork.scpt')
  `osascript "#{artwork_script}"` if File.exists?(artwork_script)
end

def track_info(clause)
  script = %Q{tell application "iTunes" to get #{clause} of current track}
  #puts "Running: #{script}"
  `osascript -e '#{script}'`.strip
end

# Get track info
track = {}
track[:id]     = track_info 'id'

# If our IDs match, there is no reason to re-do all of this
Kernel.exit 0 if cache_file && cache_file[:id] == track[:id]

track[:name]   = track_info 'name'
track[:artist] = track_info 'artist'
track[:album]  = track_info 'album'
track[:rating] = track_info('rating').to_i
track[:stars]  = (track[:rating]/20)
update_album_artwork

File.open(cache_file_path, 'w') { |f| f.write(track.to_yaml) }