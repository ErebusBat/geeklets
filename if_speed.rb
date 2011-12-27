#!/usr/bin/env ruby

DEBUG=false

def debug msg
  $stderr.puts "***DEBUG: #{msg}" if DEBUG
end


def netstat_interface_info iface
  netstat = `netstat -ib -I#{iface}`
  debug "Netstat output for #{iface}:\n#{netstat}"
  #parser_rx = /^#{iface}\s+(\d+)\s+([^ ]+)\s+([^ ]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)/i
  parser_rx = /^#{iface}\s+(\d+)\s+([^ ]+)\s+(\d+\.\d+\.\d+\.\d+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)\s+([-0-9]+)/i
  if_info = { :iface => iface }
  m = parser_rx.match(netstat)
  # 0     1       2             3                 4     5         6         7     8          9     10
  #Name  Mtu   Network       Address            Ipkts Ierrs     Ibytes    Opkts Oerrs     Obytes  Coll
  #en1   1500  <Link#5>    e4:ce:8f:12:4a:e0 18500626     0 4448877248 49947066     0 43217836970     0
  #en1   1500  horcrux.loc fe80:5::e6ce:8fff 18500626     - 4448877248 49947066     - 43217836970     -
  #en1   1500  10.32.10/26   10.32.10.15     18500626     - 4448877248 49947066     - 43217836970     -
  if m
    if_info[:mtu]          = m[1]
    if_info[:network]      = m[2]
    if_info[:address]      = m[3]
    if_info[:in_packets]   = m[4].to_i
    if_info[:in_errors]    = m[5]
    if_info[:in_bytes]     = m[6].to_i
    if_info[:out_packets]  = m[7].to_i
    if_info[:out_errors]   = m[8]
    if_info[:out_bytes]    = m[9].to_i
  end
  if_info
end

# get the current number of bytes in and bytes out
iface = 'en1'
bytes_in = []
bytes_out = []
#bytes_in << `netstat -ib -I #{iface} | grep -e "#{iface}" -m 1 | awk '{print $7}'` #  bytes in
#bytes_out << `netstat -ib -I #{iface} | grep -e "#{iface}" -m 1 | awk '{print $10}'` # bytes out
if_info = netstat_interface_info(iface)
bytes_in  << if_info[:in_bytes]
bytes_out << if_info[:out_bytes]

#wait one second
sleep 1

# get the number of bytes in and out one second later
if_info = netstat_interface_info(iface)
bytes_in  << if_info[:in_bytes]
bytes_out << if_info[:out_bytes]

# find the difference between bytes in and out during that one second
rate_in = bytes_in.last - bytes_in.first
rate_out= bytes_out.last - bytes_out.first

# convert bytes to kilobytes
kbin= rate_in / 1024.0
kbout= rate_out / 1024.0

# print the results
puts " In:%7.2f KB/s" % kbin
puts "Out:%7.2f KB/s" % kbout