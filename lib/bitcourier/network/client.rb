require 'timeout'

module Bitcourier
  module Network
    class Client
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
                sleep(Bitcourier::CONFIG[:next_peer_delay])
              end
            else
              sleep(Bitcourier::CONFIG[:next_peer_delay])
            end
          end
        end
      end

      private

      def next_peer_connection
        socket = nil

        if peer = @context.peer_list.next
          print "Connecting to #{peer.ip}:#{peer.port}... "

          timeout(Bitcourier::CONFIG[:connect_timeout]) do
            socket = TCPSocket.new(peer.ip, peer.port)
          end

          print "Connected.\n"

          peer.touch
          @context.peer_list.store(peer)
        end
      rescue Errno::ECONNREFUSED
        print "Connection refused.\n"

        peer.retry_in Bitcourier::CONFIG[:peer_connection_retry_delay]
        @context.peer_list.store(peer)
      rescue Errno::ETIMEDOUT, Timeout::Error
        print "Timed out.\n"

        peer.retry_in Bitcourier::CONFIG[:peer_connection_retry_delay]
        @context.peer_list.store(peer)
      rescue Exception => e
        print "#{e.class}: #{e}\n"
        puts e.backtrace
      ensure
        return socket
      end
    end
  end
end
