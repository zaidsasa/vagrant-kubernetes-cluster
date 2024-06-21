class IPBlocks
  def initialize(cidr, length, skipFirstIPsCount = 0)
    ips = []
    for a in 1..length do
      v = IPAddr.new(cidr)|a +skipFirstIPsCount
      ips.append(v)
    end
    @ips = ips
  end

  def GetNewIP()
    return @ips.shift(1)[0].to_s
  end
end
