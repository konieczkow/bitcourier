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

    def run(options = {})
      server.port = options.fetch(:port, Network::Server::DEFAULT_PORT)

      start
    end

    private

    def start
      Thread.abort_on_exception = true

      server_thread = server.run
      client_thread = client.run

      server_thread.join
      client_thread.join
    end

  end

end
