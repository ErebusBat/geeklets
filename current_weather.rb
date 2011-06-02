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
  case d
    when (  0   .. 11.25),
         (348.75..360)
			"N"
    when ( 11.25.. 33.75)
			"NNE"
    when ( 33.75.. 56.25)
			"NE"

    when ( 56.25.. 78.75)
			"ENE"
    when ( 78.75..101.25)
			"E"
    when (101.25..123.75)
			"ESE"

    when (123.75..146.25)
			"SE"
    when (146.25..168.75)
			"SSE"
    when (168.75..191.25)
			"S"
    when (191.25..213.75)
			"SSW"
    when (213.75..236.25)
			"SW"

    when (236.25..258.75)
			"WSW"
    when (258.75..281.25)
			"W"
    when (281.25..303.75)
			"WNW"
    when (303.75..326.25)
			"NW"
    when (326.25..348.75)
			"NNW"
    else
      "#{d}°"
  end
end

woeid = 12793608 # 12793608=Casper,WY
weather = get_weather woeid

temp = "#{weather.condition.text}, #{weather.condition.temp}°F"
wind = "Wind: #{deg_to_dir weather.wind.direction} #{weather.wind.speed}mph, Chill:#{weather.wind.chill}°F"
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