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
          puts "Connecting to peer #{peer[0]} on port #{peer[1]}"

          socket = TCPSocket.new(peer[0], peer[1])

          @context.peer_list.store(peer[0], peer[1], Time.now, nil)

          socket
        end
      rescue Errno::ECONNREFUSED
        puts 'Connection refused'

        @context.peer_list.store(peer[0], peer[1], peer[2], Time.now + PEER_CONNECTION_RETRY_DELAY)

        nil
      end
      
    end

  end
end
