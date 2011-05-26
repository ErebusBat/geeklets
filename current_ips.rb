#!/usr/bin/env ruby -I.

require "rubygems"
require "bundler/setup"
require "thread"
require "active_support"
require "yaml"

require "framework/colors"
require "framework/network"

IP_CACHE_PATH = '/tmp/geeklet_ip.cache'

def load_cache
  return {} unless File.exists? IP_CACHE_PATH
  # loads a cache file based on default GW, this minimizes the calls to .external_ip which hit an external server
  # if the cache exists, and is under an hour old then that is used for the external IP
  YAML.load_file(IP_CACHE_PATH)
end

def get_key_for_ip ip
  return 'no_ip' if ip.to_s.empty?
  no_dots = ip.gsub '.', '_'
  "gw#{no_dots}".to_sym
end

def get_blank_cache_entry
  {
      :external_ip => '',
      :last_updated => Time.now
  }
end

def get_ips cache_entry
  ips = []

  update_external_ip = false
  update_external_ip = true if cache_entry[:external_ip].to_s.empty?
  update_external_ip = true if (Time.now - cache_entry[:last_updated] > 60.minutes)
  cache_entry[:external_ip] = Network.external_ip if update_external_ip
  puts "NEW EXTERNAL IP" if update_external_ip
  eip = "#{cache_entry[:external_ip]} a=#{(Time.now - cache_entry[:last_updated]).ceil}"

  ips << ['world',  eip]
  Network.interface_list.each do |iif|
    next if iif[:status] != :active || iif[:ip].to_s.empty? ||
    ips << [iif[:name], iif[:ip]]
  end
  ips
end

def display_ips ips
  # Print them
  #puts "#{Colors.white}Current IPs#{Colors.normal}"
  ips.each do |iif, ip|
    puts "#{'%6s' % iif}: #{ip}"
  end
end

cache = load_cache
gw = Network.default_gateway
cache_key = get_key_for_ip gw
if cache.key? cache_key
  cache_entry = cache[cache_key] 
else  
  cache_entry = get_blank_cache_entry
  cache[cache_key] = cache_entry
end
  
ips = get_ips cache_entry
display_ips ips

# Re-write the cache
File.open(IP_CACHE_PATH, 'w') { |f| f.puts cache.to_yaml }