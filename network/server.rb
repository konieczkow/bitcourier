require 'socket'

module Network
  class Server
    def run
      @server = TCPServer.new 6060

      loop do
        client = @server.accept

        c = Connection.new client
        c.run
      end
    end
  end
end
