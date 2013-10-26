module Elchat
  module Protocol
    module Message

      class PeerInfo < Base
        ID = 0x3

        attr_accessor :ip, :port, :last_seen_at

        def payload
          [*ip_array, port.to_i, last_seen_at.to_i].pack('CCCCSL')
        end

        def extract bytes
          data = bytes.unpack('CCCCSL')

          self.ip           = data[0..3].join('.')
          self.port         = data[4].to_i
          self.last_seen_at = Time.at(data[5].to_i)

          self
        end

        private

        def ip_array
          ip.split('.').map(&:to_i)
        end

      end

    end
  end
end
