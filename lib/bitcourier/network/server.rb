require 'socket'

module Bitcourier
  module Network
    class Server
      DEFAULT_PORT = 6081

      attr_reader :port

      def initialize(context, options = {})
        @context = context
        @port    = options.fetch(:port, DEFAULT_PORT)
      end

      def run
        @server = TCPServer.new port

        puts "Started server on port #{port}"

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
