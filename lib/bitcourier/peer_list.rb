module Bitcourier
  class PeerList

    attr_reader :peers

    def initialize
      @peers   = []
      @storage = PeerListFileStorage.new(self)

      load
    end

    def store(peer)
      if existing = find(peer)
        existing.update(peer)
      else
        peers << peer
      end

      save
    end

    def next(options = {})
      pool = peers.select(&:can_connect?)
      
      if except = options[:except]
        pool.delete_if { |peer| except.include?(peer.address) }
      end

      pool.sample
    end

    private

    attr_reader :storage

    def find(peer)
      peers.detect { |existing| existing == peer }
    end

    def save
      storage.write
    end

    def load
      storage.read

      puts "LOADED:"
      puts peers

      seed if peers.size == 0
    end

    def seed
      store Peer.new(Bitcourier::CONFIG[:peer_seed], Bitcourier::CONFIG[:default_port])
    end

  end
end
