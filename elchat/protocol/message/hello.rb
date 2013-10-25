module ElChat
  module Protocol
    module Message
      class Hello < Base
        ID              = 0x1
        DEFAULT_VERSION = 1

        attr_accessor :version, :port, :nonce

        def initialize
          self.version = DEFAULT_VERSION
        end

        def payload
          [version.to_i, port.to_i, nonce.to_i].pack('SSQ')
        end

        def extract data
          a = data.unpack('SSQ')
          self.version = a[0]
          self.port = a[1]
          self.nonce = a[2]
        end
      end
    end
  end
end
