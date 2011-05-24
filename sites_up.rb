#!/usr/bin/env ruby -I.

require "framework/colors"
require "framework/network"

sites_to_check = [
  # Display   Host Address
  ['IT34',   'it34.natrona.net'],
  ['Google', 'www.google.com'],
  ['WHF',    '10.32.10.4'],
  ['Home Server (Internal)', '10.0.1.200'],
  ['Home Server (External)', 'home.batcavern.com']
]

def get_site_string site_info
  is_up = Network.site_up? site_info[1]
  status = " UP "
  status = "DOWN" unless is_up

  # color it
  if is_up
    status = "#{Colors.green}#{status}#{Colors.normal}"
  else
    status = "#{Colors.red}#{status}#{Colors.normal}"
  end

  "[#{status}] #{site_info[0]}"
end

# Do default gateway before other sites
gw = Network.default_gateway
sites_to_check.unshift ["GW: #{gw}", gw]

# now other sites
sites_to_check.each do |site_info|
  puts get_site_string site_info
end