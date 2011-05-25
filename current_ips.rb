#!/usr/bin/env ruby -I.

require "framework/colors"
require "framework/network"

ignore_interfaces = ['lo0', 'fw', 'vmnet1', 'vmnet8']

ips = []
ips << ['world', Network.external_ip]
Network.interface_list.each do |iif|
  next if ignore_interfaces.include? iif
  if_ip = Network.ip_for_interface iif
  ips << [iif, if_ip] unless if_ip.to_s.empty?
end


# Print them
#puts "#{Colors.white}Current IPs#{Colors.normal}"
ips.each do |iif, ip|
  puts "#{'%5s' % iif}: #{ip}"
end