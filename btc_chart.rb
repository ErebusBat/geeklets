#!/usr/bin/env ruby
require 'ostruct'
require 'pathname'
require 'open-uri'

#┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
# Support Functions
#┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
def absolute_path path, ref=nil
  # Save current working dir
  old_cwd = Dir.pwd
  ref = old_cwd unless ref

  # Extract the full path, then restore CWD
  pn = Pathname.new(path)
  Dir.chdir ref
  absolute_path = pn.realpath
  Dir.chdir old_cwd

  absolute_path
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
options = OpenStruct.new
options.chart = ARGV[0].to_s.downcase
options.base_dir = '/tmp'

# Charts are PNG image data, 940 x 348, 8-bit/color RGB, non-interlaced

case options.chart
  when '1d-1m'
    options.web_url   = 'http://bitcoincharts.com/charts/mtgoxUSD#rg1zig1-minztgSzbgBza1gSMAzm1g60za2gSMAzm2g1440zxzvzl'
    options.chart_url = 'http://bitcoincharts.com/charts/chart.png?width=940&m=mtgoxUSD&SubmitButton=Draw&r=1&i=1-min&c=0&s=&e=&Prev=&Next=&t=S&b=B&a1=SMA&m1=60&a2=SMA&m2=1440&x=1&i1=&i2=&i3=&i4=&v=1&cv=0&ps=0&l=1&p=0&'
  when '1d-15m'
    options.web_url   = 'http://bitcoincharts.com/charts/mtgoxUSD#rg1zig15-minztgSzbgBza1gSMAzm1g200za2gSMAzm2g50zxzl'
    options.chart_url = 'http://bitcoincharts.com/charts/chart.png?width=940&m=mtgoxUSD&SubmitButton=Draw&r=1&i=15-min&c=0&s=&e=&Prev=&Next=&t=S&b=B&a1=SMA&m1=200&a2=SMA&m2=50&x=1&i1=&i2=&i3=&i4=&v=0&cv=0&ps=0&l=1&p=0&'
  when '2m-1d'
    options.web_url   = 'http://bitcoincharts.com/charts/mtgoxUSD#rg60zigDailyztgSzbgBza1gSMAzm1g20za2gSMAzm2g50zxzv'
    options.chart_url = 'http://bitcoincharts.com/charts/chart.png?width=940&m=mtgoxUSD&SubmitButton=Draw&r=60&i=Daily&c=0&s=&e=&Prev=&Next=&t=S&b=B&a1=SMA&m1=20&a2=SMA&m2=50&x=1&i1=&i2=&i3=&i4=&v=1&cv=0&ps=0&l=0&p=0&'
  else
    $stderr.puts "***ERROR: specify chart type:\n   #{$0} 1d1m"
    Kernel.exit 1
end

# Fetch the chart
download_chart options