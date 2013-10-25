module ElChat
  module Protocol
    module Message
      class Version < Base
        ID              = 0x1
        DEFAULT_VERSION = 1

        attr_accessor :version

        def initialize
          self.version = DEFAULT_VERSION
        end

        def payload
          [version].pack('S')
        end

        def extract data
          self.version = data.unpack('S').first
        end
      end
    end
  end
end
