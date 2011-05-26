#!/usr/bin/env ruby -I.

require "framework/colors"
require "framework/network"

ips = []
ips << ['world', Network.external_ip]
Network.interface_list.each do |iif|
  next if iif[:status].nil? || iif[:status] == "inactive"
  ips << [iif[:name], iif[:ip]]
end


# Print them
#puts "#{Colors.white}Current IPs#{Colors.normal}"
ips.each do |iif, ip|
  puts "#{'%6s' % iif}: #{ip}"
end