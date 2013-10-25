module ElChat

  class Daemon
    attr_accessor :server, :client, :node_manager, :peer_list

    def initialize
      self.server       = Network::Server.new self
      self.node_manager = NodeManager.new self
      self.client       = Network::Client.new self
      self.peer_list    = PeerList.new
    end

    def start
      server_thread = server.run
      client_thread = client.run

      server_thread.join
      client_thread.join
    end

    def run(port)
      server.port = port

      start
    end
  end

end

Thread.abort_on_exception = true
