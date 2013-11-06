module Bitcourier
  class Address
    attr_accessor :ip, :port

    def initialize ip, port = 6081
      self.ip = ip
      self.port = port
    end

    def equals?(address)
      address.is_a?(Address) and (address.ip == self.ip) and (address.port == self.port)
    end

    def to_s
      "#{ip}:#{port}"
    end
  end
end
