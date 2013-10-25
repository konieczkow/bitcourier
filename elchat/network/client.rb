module ElChat
  module Network

    class Client

      def initialize context
        @context = context
      end

      def run
        @thread = Thread.new do
          loop do
            if @context.node_manager.needs_nodes?
              if conn = new_connection
                @context.node_manager.add_socket conn, true
              else
                sleep(5000)
              end
            else
              sleep(5000)
            end
          end
        end
      end

      private

      def new_connection
        peer = @context.peer_list.next

        if peer
          ip, port = peer[0], peer[1]
        else
          ip, port = '127.0.0.1', $client_port
        end

        puts "Connecting to peer #{ip} on port #{port}"

        TCPSocket.new(ip, port)
      rescue Errno::ECONNREFUSED
        puts "Connection refused"

        @context.peer_list.store(peer[0], peer[1], peer[2], Time.now + 60 * 10)

        nil
      end

    end

  end
end
