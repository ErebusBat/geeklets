sites_to_check = [
  # Display   Host Address
  ['IT34',   'it34.natrona.net'],
  ['Google', 'www.google.com'],
  ['WHF',    '10.32.10.4']
]

def site_up? addr
  ping = `ping -c 1 -t 1 #{addr} 2>&1`
  return false if ping =~ /Unknown host$/i
  return false if ping =~ /100(?:\.0)?% packet loss/i
  return true  if ping =~ /0(?:\.0)?% packet loss/i
end

def get_site_string site_info
  is_up = site_up? site_info[1]
  up = ' UP '
  up = 'DOWN' unless is_up
  "[#{up}] #{site_info[0]}"
end

sites_to_check.each do |site_info|
  puts get_site_string site_info
end