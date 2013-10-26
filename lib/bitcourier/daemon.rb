require 'securerandom'

module Bitcourier

  class Daemon
    attr_accessor :server, :client, :node_manager, :peer_list, :nonce

    def initialize
      self.server       = Network::Server.new self
      self.node_manager = NodeManager.new self
      self.client       = Network::Client.new self
      self.peer_list    = PeerList.new
      self.nonce        = SecureRandom.random_number(2**64)
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
