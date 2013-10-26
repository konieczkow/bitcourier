module Elchat
  module Protocol
    module Message
      class Base
        MAGIC_BYTES = 0x1234
        HEADER_SIZE = 6

        def header
          [MAGIC_BYTES, self.class::ID, payload.size].pack('SSS')
        end

        def payload
          ''
        end

        def pack
          header + payload
        end

        def extract bytes
        end

        def self.unpack bytes
          magic, id, length = unpack_header(bytes)

          return nil if magic != MAGIC_BYTES # wrong magic
          return nil if length + HEADER_SIZE > bytes.size # partial package
          return nil unless klass = find_message_class(id)

          msg = klass.new
          msg.extract bytes[HEADER_SIZE..-1]

          msg
        end

        def self.message_size bytes
          return 0 if bytes.size < HEADER_SIZE

          _, _, length = unpack_header(bytes)

          return 0 if bytes.size < (length + HEADER_SIZE)

          return length + HEADER_SIZE
        end

        private

        def self.unpack_header bytes
          bytes[0...HEADER_SIZE].unpack('SSS')
        end

        def self.find_message_class id
          [Hello, GetPeerList, PeerInfo].each do |message_class|
            return message_class if message_class::ID == id
          end

          nil
        end
      end
    end
  end
end
