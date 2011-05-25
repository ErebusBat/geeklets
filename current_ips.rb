#!/usr/bin/env ruby -I.

require "framework/colors"
require "framework/network"

ips = []
current_ips = Network.ips
current_ips.each do |ip|
  show_ip = true
  #show_ip = false if Network.ip_matches_pattern ip,
  ips << ip
end

# Print them
puts "#{Colors.white}Current IPs#{Colors.normal}"
ips.each do |ip|
  puts "  #{ip}"
end