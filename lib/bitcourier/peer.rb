module Bitcourier
  class Peer
    attr_accessor :ip, :port, :last_seen_at, :next_connection_at

    def initialize ip, port, last_seen_at = nil, next_connection_at = Time.now.utc
      self.ip                 = ip
      self.port               = port
      self.last_seen_at       = last_seen_at
      self.next_connection_at = next_connection_at
    end

    def touch(timestamp = Time.now.utc)
      self.last_seen_at = [last_seen_at || Time.at(0).utc, timestamp || Time.now.utc].max
    end

    def update(peer)
      touch(peer.last_seen_at)
      self.next_connection_at = peer.next_connection_at
    end

    def can_connect?(time = Time.now.utc)
      next_connection_at < time
    end

    def retry_in delay
      self.next_connection_at = Time.now + delay
    end

    def to_a
      [
          ip,
          port,
          last_seen_at && last_seen_at.to_i,
          next_connection_at && next_connection_at.to_i
      ]
    end

    def same?(other)
      equals?(other)
    end

    def equals?(peer)
      peer.is_a?(Peer) && (ip == peer.ip) && (port == peer.port)
    end

    def self.from_a a
      new(a[0], a[1].to_i, a[2] && Time.at(a[2].to_i).utc, a[3] && Time.at(a[3].to_i).utc)
    end
  end
end
