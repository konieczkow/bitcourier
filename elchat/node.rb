module ElChat
  class Node
    
    class State
      class Unimplemented < StandardError; end

      attr_accessor :node

      def initialize node
        self.node = node
      end

      def on_version
        raise Unimplemented
      end

      def set_state state
        node.set_state state
      end

      def on_enter
      end

      def on_leave
      end
    end

    class ActiveHandshake < State
      def on_enter
        node.send_message(Protocol::Message::Version.new)
      end

      def on_version msg
        if msg.version == Protocol::Message::Version::DEFAULT_VERSION
          set_state ReadyState
        end
      end
    end

    class PassiveHandshake < State
      def on_version msg
        if msg.version == Protocol::Message::Version::DEFAULT_VERSION
          node.send_message(Protocol::Message::Version.new)
          set_state ReadyState
        end
      end
    end

    class ReadyState < State
      def on_enter
        puts 'ReadyState#on_enter'
      end
    end

    attr_accessor :socket

    def initialize(socket)
      self.socket = socket
    end
    
    def set_state state
      self.state.on_leave if self.state
      self.state = state.new(self)
      self.state.on_enter
    end

    def send_message msg
      data = msg.pack
      socket.write data
    end

    def on_message msg
      return if state.nil?

      if msg.is_a? Protocol::Message::Version
        state.on_version msg
      end
    end

    def run
      @thread = Thread.new do
        buffer = ''

        loop do
          data = socket.recv(1024)

          break if data.length == 0

          buffer += data

          message_size = Protocol::Message::Base.message_size(buffer)

          if message_size
            message_data = buffer.slice!(0, message_size)

            message = Protocol::Message::Base.unpack(message_data)

            on_message message
          end
        end

      end
    end

    attr_accessor :state

  end
end