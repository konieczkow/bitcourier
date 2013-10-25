module Elchat
  class PeerList
    attr_accessor :file

    def initialize
      @file = File.open('../tmp/peer_list.txt', 'w+')
    end

    def store_peers(peer_array = [])
      peer_array.each do |peer|
        self.store(peer.ip, peer.port, peer.last_seen_at)
      end
    end

    def store(ip, port, last_seen_at)
      file.write("#{ip}|#{port}|#{last_seen_at},")
      file.write("\n")
    end

    def list
      @list ||= File.read('filename').split(',').split('|')
    end

    def reload
      @list = File.read('filename').split(',').split('|')
    end

    def next
      return false
    end
  end
end