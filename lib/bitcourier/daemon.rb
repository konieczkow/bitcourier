require 'securerandom'

module Bitcourier

  class Daemon
    attr_accessor :server, :client, :node_manager, :peer_list, :nonce

    def initialize options = {}
      self.server       = Network::Server.new self, port: options[:port]
      self.node_manager = NodeManager.new self, target_connections: options[:target_connections]
      self.client       = Network::Client.new self
      self.peer_list    = PeerList.new
      self.nonce        = SecureRandom.random_number(2**64)
    end

    def run
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
