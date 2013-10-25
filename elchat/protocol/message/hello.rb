module ElChat
  module Protocol
    module Message
      class Hello < Base
        ID               = 0x1
        PROTOCOL_VERSION = 1

        attr_accessor :protocol_version, :port, :nonce

        def initialize
          self.protocol_version = PROTOCOL_VERSION
        end

        def payload
          [protocol_version.to_i, port.to_i, nonce.to_i].pack('SSQ')
        end

        def extract bytes
          data = bytes.unpack('SSQ')

          self.protocol_version = data[0]
          self.port             = data[1]
          self.nonce            = data[2]
        end

      end
    end
  end
end
