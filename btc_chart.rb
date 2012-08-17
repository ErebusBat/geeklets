#!/usr/bin/env ruby
require 'ostruct'
require 'fileutils'
require 'open-uri'
require 'yaml'

#┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
# Support Functions
#┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
CONFIG_PATH=File.expand_path('~/.btc_charts.yml')
def copy_example
  puts "No config file exists... creating new one #{CONFIG_PATH}"
  `cp #{File.expand_path('./btc_charts.example.yml')} #{CONFIG_PATH}`
end
def load_config
  copy_example unless File.exists? CONFIG_PATH
  File.open CONFIG_PATH, 'r' do |f|
    return YAML::load(f.read)
  end
end

def find_chart config, chart
  return nil if config.nil? or chart.to_s.empty?
  config[:charts].each { |c| return c if c[:chart] == chart }
  return nil
end

def download_file uri, local_file
  open(local_file, 'wb') do |fo|
    fo.print open(uri).read
  end
end

def download_chart options
  # Use chart name as base name if one was not specified
  options.save_to = "btc_#{options.chart}.png" unless options.save_to
  # Expand path if a full path was not specified
  options.save_to = File.expand_path(options.save_to, options.base_dir)
  save_to = options.save_to

  # Log and download
  puts %Q{Fetching the #{options.chart} chart:
       WEB: #{options.web_url}
     CHART: #{options.chart_url}
     LOCAL: #{save_to}
  }

  # First see if it exists, and if it does rm it
  File.delete save_to if File.exists? save_to

  #cmd = %Q%wget --quiet -O #{options.save_to} #{options.chart_url}%
  #cmd = %Q%curl --output #{save_to} #{options.chart_url}%

  #puts "Downloading chart:\n  #{cmd}"
  #puts `#{cmd}`
  download_file options.chart_url, options.save_to
end

#┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
# Entry Point
#┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
config = load_config
charts = config[:charts]
options = OpenStruct.new
options.chart = ARGV[0].to_s.downcase
options.base_dir = config[:basedir]
chart = find_chart config, options.chart

# Charts are PNG image data, 940 x 348, 8-bit/color RGB, non-interlaced
if options.chart.empty? or chart.nil?
  $stderr.puts "***ERROR: specify chart type:\n   #{$0} 1d1m"
  $stderr.puts "Valid charts are:"
  charts.each { |c| puts "  #{c[:chart]}" }
  Kernel.exit 1
else
  options.chart     = chart[:chart]
  options.web_url   = chart[:web_url]
  options.chart_url = chart[:chart_url]
end

# Fetch the chart
download_chart options