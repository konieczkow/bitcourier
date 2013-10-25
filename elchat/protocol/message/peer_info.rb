module ElChat
  module Protocol
    module Message
      class PeerInfo < Base
        ID = 0x3

        attr_accessor :ip, :port, :last_seen_at

        def ip_array
          ip.split('.').map { |s| s.to_i }
        end

        def payload
          [ip_array, port.to_i, last_seen_at.to_i].flatten.pack('CCCCSL')
        end

        def extract data
          a = data.unpack('CCCCSL')

          self.ip = a[0..3].join('.')
          self.port = a[4].to_i
          self.last_seen_at = Time.at(a[5].to_i)

          return self
        end
      end
    end
  end
end
