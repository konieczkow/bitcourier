module Bitcourier
  class Peer
    attr_accessor :last_seen_at, :next_connection_at

    attr_reader :address

    def self.from_a array
      new(array[0], array[1].to_i, array[2] && Time.at(array[2].to_i).utc, array[3] && Time.at(array[3].to_i).utc)
    end

    def initialize(ip, port, last_seen_at = nil, next_connection_at = Time.now.utc)
      @address = Address.new(ip, port)

      self.last_seen_at       = last_seen_at
      self.next_connection_at = next_connection_at
    end

    def ==(other)
      equal?(other) || (other.instance_of?(self.class) && (other.address == address))
    end

    def touch(timestamp = Time.now.utc)
      self.last_seen_at = [last_seen_at || Time.at(0).utc, timestamp || Time.now.utc].max
    end

    def update(peer)
      touch(peer.last_seen_at)

      self.next_connection_at = peer.next_connection_at
    end

    def can_connect?(time = Time.now.utc)
      next_connection_at <= time
    end

    def retry_in(seconds)
      self.next_connection_at = Time.now.utc + seconds
    end

    def ip
      address.ip
    end

    def port
      address.port
    end

    def to_a
      [
          *address.to_a,
          last_seen_at && last_seen_at.to_i,
          next_connection_at && next_connection_at.to_i
      ]
    end

  end
end
