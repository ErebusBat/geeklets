#!/usr/bin/env ruby -I.
require "rubygems"
require "yahoo-weather"

def get_weather woeid
  yahoo = YahooWeather::Client.new
  yahoo.lookup_by_woeid woeid
end

woeid = 12793608 # 12793608=Casper,WY
weather = get_weather woeid

temp = "#{weather.condition.text}, #{weather.condition.temp}°F"
wind = "Wind: #{weather.wind.speed}mph #{weather.wind.direction}°, Chill:#{weather.wind.chill}°F"
wind = "Calm" if weather.wind.speed <= 1

output = <<END
#{weather.title}
#{temp} #{wind}
#{weather.image.url}
END

puts output.strip