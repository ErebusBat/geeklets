class Network
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
    return true unless ping < 0 || ping > timeout
  end
end