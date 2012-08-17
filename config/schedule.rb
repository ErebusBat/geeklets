# whenever -w geeklets
# WARNING: IT APPEARTS THAT ON OSX THE ABOVE COMMAND *WILL* DESTORY YOUR EXISTING CRONTAB

# Learn more: http://github.com/javan/whenever

set :output, '/tmp/geeklet.cron.log'

chart_cmd = "cd :path && /usr/bin/ruby -I. ./btc_chart.rb :task :output"
job_type :bash, "cd :path && :task :output"
job_type :script, "cd :path && /usr/bin/ruby -I. :task :output"

# By sleeping for 1min it gives time for the charts/data to be updated on the remote server
job_type :chart, chart_cmd
job_type :sleep_chart, "sleep 60; #{chart_cmd}"

every :reboot do
  chart '1d-1m'
  chart '1d-15m'
  chart '2m-1d'
end

every 1.minutes do
  chart '1d-1m'
end

every 15.minutes do
  sleep_chart '1d-15m'
end

every 24.hours do
  chart '2m-1d'
end