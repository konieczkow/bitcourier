require_relative 'network'
require_relative 'protocol'

class P2p
  def run
    server = Network::Server.new

    @server = Thread.new do
      server.run
    end

    @server.join
  end
end

P2p.new.run
