#!/usr/bin/env ruby

# get the current number of bytes in and bytes out
iface = 'en1'
bytes_in = []
bytes_out = []
bytes_in << `netstat -ib -I #{iface} | grep -e "#{iface}" -m 1 | awk '{print $7}'` #  bytes in
bytes_out << `netstat -ib -I #{iface} | grep -e "#{iface}" -m 1 | awk '{print $10}'` # bytes out

#wait one second
sleep 1

# get the number of bytes in and out one second later
bytes_in << `netstat -ib | grep -e "en1" -m 1 | awk '{print $7}'` # bytes in again
bytes_out << `netstat -ib | grep -e "en1" -m 1 | awk '{print $10}'` # bytes out again

# find the difference between bytes in and out during that one second
rate_in = bytes_in.last.to_i - bytes_in.first.to_i
rate_out= bytes_out.last.to_i - bytes_out.first.to_i

# convert bytes to kilobytes
kbin= rate_in / 1024.0
kbout= rate_out / 1024.0

# print the results
puts " In:%7.2f KB/s" % kbin
puts "Out:%7.2f KB/s" % kbout