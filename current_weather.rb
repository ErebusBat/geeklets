#!/usr/bin/env ruby -I.
require "rubygems"
require "yahoo-weather"
require "date"

def get_weather woeid
  yahoo = YahooWeather::Client.new
  yahoo.lookup_by_woeid woeid
end

def get_img_url code, big = true, day = nil
  #See http://developer.yahoo.com/weather/ for explanation of codes
  code = code.to_i
  raise "Code (#{code}) does not appear to be a valid yahoo weather code!" unless (code >= 0 && code <=47) || code==3200
  url = ""
  if big
    if day = nil?
      if DateTime.now.hour >= 18
        day_or_night = 'n'
      else
        day_or_night = 'd'
      end
    else
      day_or_night = day ? 'd' : 'n'
    end
    url = "http://l.yimg.com/a/i/us/nws/weather/gr/#{code}#{day_or_night}.png"
  else
    url = "http://l.yimg.com/a/i/us/we/52/#{code}.gif"
  end
  url
end

def download_weather_image code, store_at="/tmp/weather.gif"
  url = get_img_url code
  File.delete store_at if File.exists? store_at
  %x[wget -q #{url} -O #{store_at}]
end

def deg_to_dir deg
  # used logic from http://www.csgnetwork.com/degrees2direct.html
  d = deg.to_f
  dir = "#{d}°"
  case d
    when d >=  0    && d <=  11.25,
         d > 348.75 && d <= 360
      dir = "N"
    when d >  11.25 && d <=  33.75
      dir = "NNE"
    when d >  33.75 && d <=  56.25
      dir = "NE"

    when d >  56.25 && d <=  78.75
      dir = "ENE"
    when d >  78.75 && d <= 101.25
      dir = "E"
    when d > 101.25 && d <= 123.75
      dir = "ESE"

    when d > 123.75 && d <= 146.25
      dir = "SE"
    when d > 146.25 && d <= 168.75
      dir = "SSE"
    when d > 168.75 && d <= 191.25
      dir = "S"
    when d > 191.25 && d <= 213.75
      dir = "SSW"
    when d > 213.75 && d <= 236.25
      dir = "SW"

    when d > 236.25 && d <= 258.75
      dir = "WSW"
    when d > 258.75 && d <= 281.25
      dir = "W"
    when d > 281.25 && d <= 303.75
      dir = "WNW"
    when d > 303.75 && d <= 326.25
      dir = "NW"
    when d > 326.25 && d <= 348.75
      dir = "NNW"
  end
  dir
end

woeid = 12793608 # 12793608=Casper,WY
weather = get_weather woeid

temp = "#{weather.condition.text}, #{weather.condition.temp}°F"
wind = "Wind: #{weather.wind.speed}mph #{deg_to_dir weather.wind.direction}, Chill:#{weather.wind.chill}°F"
wind = "Calm" if weather.wind.speed <= 1
forecasts = []
weather.forecasts.each do |f|
  forecasts << "#{f.day}: #{f.low}°-#{f.high}° #{f.text}"
end

output = <<END
#{weather.title}
\t\t#{temp} #{wind}
\t\t#{forecasts.join "\n\t\t"}
END
download_weather_image weather.condition.code

puts output.strip