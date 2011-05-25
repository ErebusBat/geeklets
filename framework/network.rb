class Network
  def self.ips
    ips = []
    ifconfig = %x[ifconfig]
    m = ifconfig.scan /^\s*inet\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/i
    m.each { |ip| ips << ip[0] } if m
    ips
  end

  def self.default_gateway
    routes = %x[netstat -nr]
    rx = /^default\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/i
    m = rx.match routes
    return nil unless m
    m[1]
  end

  def self.ping host
    ping = `ping -c 1 -t 1 #{host} 2>&1`
    return nil if ping =~ /Unknown host$/i
    return -1 if ping =~ /100(?:\.0)?% packet loss/i
    m = /time=(\d+(?:\.\d+)) ms/i.match ping
    m[1].to_f
  end

  def self.site_up? host, timeout = 1000
    ping = self.ping host
    return false if ping.nil?
    return true unless ( ping < 0 || ping > timeout )
  end

  def self.on_network network
    # Simple test to identify if you are on the specified network
    # at the end it will turn the network specified into a ^REGEX
    #
    # Can use * wildcard which will translate to \d{1,3} in regex parlance

    rx_str = "^#{network}"
    rx_str.gsub! '*', '\d{1,3}'
    rx_str.gsub! '.', '\.'
    rx = Regexp.new rx_str
    ips.each do |ip|
      return true if rx.match ip
    end

    # nope :(
    false
  end
end
