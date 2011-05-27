#!/usr/bin/env ruby -I.
require "rubygems"
require "yahoo-weather"

def get_weather woeid
  yahoo = YahooWeather::Client.new
  yahoo.lookup_by_woeid woeid
end

def get_img_url code
  #See http://developer.yahoo.com/weather/ for explanation of codes
  code = code.to_i
  raise "Code (#{code}) does not appear to be a valid yahoo weather code!" unless (code >= 0 && code <=47) || code==3200
  "http://l.yimg.com/a/i/us/we/52/#{code}.gif"
end

def download_weather_image code, store_at="/tmp/weather.gif"
  url = get_img_url code
  File.delete store_at if File.exists? store_at
  %x[wget -q #{url} -O #{store_at}]
end

woeid = 12793608 # 12793608=Casper,WY
weather = get_weather woeid

temp = "#{weather.condition.text}, #{weather.condition.temp}°F"
wind = "Wind: #{weather.wind.speed}mph #{weather.wind.direction}°, Chill:#{weather.wind.chill}°F"
wind = "Calm" if weather.wind.speed <= 1
forecasts = []
weather.forecasts.each do |f|
  forecasts << "#{f.day}: #{f.low}°-#{f.high}° #{f.text}"
end

output = <<END
#{weather.title}
#{temp} #{wind}
#{forecasts.join "\n"}
END
download_weather_image weather.condition.code

puts output.strip