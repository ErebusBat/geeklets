#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

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
  cache = YAML.load_file(IP_CACHE_PATH)
  cache = {} unless cache
  cache
end

def get_key_for_ip ips=[]
  return 'no_ip' if ips.nil? || ips.empty?
  key = "gw"
  ips.each{|sub_ip| key << "#{sub_ip}-"}
  key = key.gsub '.', '_'

  # Remove trailing -
  key.chop
end

def get_blank_cache_entry
  {
      :external_ip => '',
      :last_updated => Time.now
  }
end

def get_external_ip cache_entry
  raise "I need a valid cache entry!" if cache_entry.nil?

  update_external_ip = false
  update_external_ip = true if cache_entry[:external_ip].to_s.empty?
  update_external_ip = true if (Time.now - cache_entry[:last_updated] > 60.minutes)
  if update_external_ip
    cache_entry[:external_ip] = Network.external_ip
    cache_entry[:last_updated] = Time.now
  end
  return '' if cache_entry[:external_ip].to_s.empty?
  "#{cache_entry[:external_ip]} a=#{(Time.now - cache_entry[:last_updated]).ceil}"
end

def get_ips cache_entry
  ips = []
  external_ip = get_external_ip cache_entry
  if external_ip.empty?
    ips << ['No Active Interfaces', '']
  else
    ips << ['world', external_ip] 
  end
  Network.interface_list.each do |iif|
    iif[:status] = :active if iif[:name] =~ /^(utun|ppp)/i
    next if iif[:status] != :active || iif[:ip].to_s.empty?
    next if iif[:name] =~ /(?:lo\d+|vmnet\d+)/i # Ignored interfaces
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