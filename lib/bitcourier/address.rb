module Bitcourier
  class Address
    attr_reader :ip, :port

    def initialize(ip, port)
      @ip   = ip
      @port = port
    end

    def ==(other)
      equal?(other) || (other.instance_of?(self.class) && (other.ip == ip) && (other.port == port))
    end

    def to_s
      "#{ip}:#{port}"
    end

    def to_a
      [ip, port]
    end

  end
end
