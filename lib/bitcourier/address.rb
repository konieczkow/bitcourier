module Bitcourier
  class Address < Struct.new(:ip, :port)
    private :ip=, :port=

    def initialize(ip, port)
      self.ip   = ip   || raise(ArgumentError, 'IP must be present')
      self.port = port || raise(ArgumentError, 'port must be present')
    end

    def to_s
      "#{ip}:#{port}"
    end

  end
end
