require 'socket'
module ElChat
  module Network
    class Server
      DEFAULT_PORT = 6081

      attr_accessor :port

      def initialize context, port = DEFAULT_PORT
        @port = port
        @context = context
      end

      def run
        @server = TCPServer.new @port

        puts "Started server on port #{@port}"

        @thread = Thread.new do
          loop do
            socket = @server.accept
            @context.node_manager.add_socket socket, false
          end
        end
      end

      def ip_string

      end
    end
  end
end
