module Elchat
  class PeerList

    attr_accessor :list

    def initialize
      @storage = Storage.new
      @list = @storage.read
    end

    def store_peers(peer_array = [])
      peer_array.each do |peer|
        self.store(peer.ip, peer.port, peer.last_seen_at)
      end
    end

    def store(ip, port, last_seen_at)
      (list << [ip, port, last_seen_at]) if last_seen_validity(last_seen_at) && not_on_the_list(ip, port)
      return list
    end

    def save
      @storage.write(list)
    end

    #TODO: what to do? =]
    def next
      return false
    end

    def on_the_list(ip, port)
      peer_on_list = false

      list.each do |peer|
        peer_on_list = true if (peer.include?(ip) && peer.include?(port))
      end

      return peer_on_list
    end

    def not_on_the_list(ip, port)
      !on_the_list(ip, port)
    end

    def last_seen_validity(last_seen_at)
      (Time.now - last_seen_at) < 7776000
    end

    class Storage
      def read
        File.read('./tmp/peer_list.txt').split(',').map{|peer| peer.split('|')}
      end

      def write(list)
        file = File.open('./tmp/peer_list.txt', 'w+')

        file.truncate(file.size)

        list.each do |peer|
          file.write("#{peer[0]}|#{peer[1]}|#{peer[2]},")
        end

        file.close

        return 'Peer list has been saved.'
      end
    end
  end
end