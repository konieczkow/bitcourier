module Bitcourier
  class PeerListStorage

    def initialize(peer_list)
      raise ArgumentError, 'peer_list must be present' unless peer_list

      @peer_list = peer_list
    end

    def read
      raise NotImplementedError
    end

    def write
      raise NotImplementedError
    end

    private

    attr_reader :peer_list

  end
end