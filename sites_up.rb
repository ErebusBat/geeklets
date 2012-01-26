#!/usr/bin/env ruby -I.
$:.unshift File.dirname(__FILE__)
require "framework/colors"
require "framework/network"

def get_sites_to_check
  # Network checks
  on_whf     = Network.on_network '10.32.*.*'
  #on_whf     = Network.on_network '192.168.1.*'
  on_home    = Network.on_network '10.0.1.*'

  sites_to_check = []

  # Always do GW, first
  gw = Network.default_gateway
  sites_to_check << ["GW: #{gw}", gw]

  # WHF
  if on_whf
    sites_to_check << ['WHF AD (.2)', '10.32.10.2']
    sites_to_check << ['WHF DB (.4)', '10.32.10.4']
    sites_to_check << ['TuxBox',      '10.32.10.47']
  end

  # Home Stuff
  if on_home
    sites_to_check << ['Home Server (Internal)', '10.0.1.20']
    sites_to_check << ['Media Server',           '10.0.1.40']
  else
    sites_to_check << [nil, 'home.batcavern.com']
  end

  # Always
  [
    # Display   Host Address
    ['Google',   'www.google.com'],
    [nil,        'www.WyomingHealthFairs.com'],
    ['WHF IDC4', '66.119.50.138']
  ].each {|s| sites_to_check << s}
  sites_to_check
end

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

  site_info[0] = site_info[1] unless site_info[0]
  "[#{status}] #{site_info[0]}"
end

#Output
sites = get_sites_to_check
sites.each do |site_info|
  puts get_site_string site_info
end