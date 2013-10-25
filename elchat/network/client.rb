module ElChat
  module Network

    class Client
      PEER_CONNECTION_RETRY_DELAY = 5 # In seconds
      NEXT_PEER_DELAY             = 5

      def initialize context
        @context = context
      end

      def run
        @thread = Thread.new do
          loop do
            if @context.node_manager.needs_nodes?
              if peer_connection = next_peer_connection
                @context.node_manager.add_socket peer_connection, true
              else
                sleep(NEXT_PEER_DELAY)
              end
            else
              sleep(NEXT_PEER_DELAY)
            end
          end
        end
      end

      private

      def next_peer_connection
        if peer = @context.peer_list.next
          puts "Connecting to peer #{peer.ip} on port #{peer.port}"

          socket = TCPSocket.new(peer.ip, peer.port)

          peer.touch
          @context.peer_list.store(peer)

          socket
        end
      rescue Errno::ECONNREFUSED
        puts 'Connection refused'

        peer.next_connection_at = Time.now + PEER_CONNECTION_RETRY_DELAY
        @context.peer_list.store(peer)

        nil
      end
      
    end

  end
end
