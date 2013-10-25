module ElChat
  class Node
    
    class State
      class Unimplemented < StandardError; end

      attr_accessor :node

      def initialize node
        self.node = node
      end

      def method_missing method, args
        name = method.id2name

        if name.start_with? 'on_'
          puts "Can't handle #{name[3..-1]} in current state"
        else
          super(method, args)
        end
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
        node.send_message(Protocol::Message::GetPeerList.new)
      end
      
      def on_get_peer_list msg
        node.send_peer_list
      end

      def on_peer_info msg
        node.on_peer_info(msg)
      end
    end

    attr_accessor :socket, :context

    def initialize(context, socket)
      self.socket = socket
      self.context = context
    end
    
    def set_state state
      self.state.on_leave if self.state
      self.state = state.new(self)
      self.state.on_enter
    end

    def send_peer_list
      context.peer_list.peers.each do |peer|
        msg = Protocol::Message::PeerInfo.new
        msg.ip = peer.ip
        msg.port = peer.port
        msg.last_seen_at = peer.last_seen_at
        send_message msg
      end
    end

    def send_message msg
      data = msg.pack
      socket.write data
    end

    def on_peer_info msg
      context.peer_list.store Peer.new(msg.ip, msg.port, msg.last_seen_at)
      puts "Peer: #{msg.ip}:#{msg.port}"
    end

    def on_message msg
      return if state.nil?

      case msg
        when Protocol::Message::Version
          state.on_version(msg)
        when Protocol::Message::GetPeerList
          state.on_get_peer_list(msg)
        when Protocol::Message::PeerInfo
          state.on_peer_info(msg)
        else
          puts "Don't know how to handle message class #{msg.class}" 
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
