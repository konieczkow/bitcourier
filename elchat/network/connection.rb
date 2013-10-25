module ElChat
  module Network
    class Connection
      class State
        class Unimplemented < StandardError;
        end

        def initialize context
          @context = context
        end

        def set_state state
          @context.set_state state
        end

        def send msg
          @context.send msg
        end

        def on_enter
        end

        def on_message msg
          raise Unimplemented
        end
      end

      class VersionState < State
        def on_message msg
          if msg.is_a? Protocol::Message::Version
            on_version msg
          end
        end

        def on_version msg
          if msg.version == 1
            puts "Version ok!"
          end
        end

        def on_enter
          v         = Protocol::Message::Version.new
          v.version = 1
          send v
        end
      end

      class << self
        attr_accessor :connections
      end

      self.connections = {}

      def set_state state
        @state = state.new(self)
        @state.on_enter
      end

      def send msg
        @client.write msg.pack
      end

      def remote_ip
        @client.addr[3]
      end

      def remote_port
        @client.addr[1]
      end

      def initialize client
        @client = client

        puts "Node conencted: #{remote_ip}"
      end

      def run
        set_state VersionState
      end
    end
  end
end