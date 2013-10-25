module ElChat

  class PeerList
    attr_accessor :list

    def initialize
      @storage = Storage.new
      @list    = @storage.read
    end

    def store_peers(peer_array = [])
      peer_array.each do |peer|
        self.store(peer.ip, peer.port, peer.last_seen_at)
      end
    end

    def store(ip, port, last_seen_at, next_connection_at)
      if peer = get(ip, port)
        peer[2] = last_seen_at if peer[2].nil? || peer[2] < last_seen_at
        peer[3] = next_connection_at
      else
        list << [ip, port, last_seen_at, next_connection_at]
      end

      @storage.write(list)
    end

    def next
      list.reject{|peer| peer[3] && peer[3] > Time.now}.sample
    end

    def get(ip, port)
      list.detect { |peer| peer[0] == ip && peer[1] == port }
    end

    class Storage
      def read
        peers = []

        File.read('./tmp/peer_list.txt').each_line do |line|
          peer_data = line.split('|')
          peer_data[2] = Time.at(peer_data[2].to_i) if peer_data[2]
          peer_data[3] = Time.at(peer_data[3].to_i) if peer_data[3]
        end

        if peers.size.zero?
          peers = add_known_peers
        end

        peers
      end

      def write(list)
        file = File.open('./tmp/peer_list.txt', 'w+')

        file.truncate(file.size)

        list.each do |peer|
          ip = peer[0]
          port = peer[1]
          last_seen_at = peer[2] ? peer[2].to_i : nil
          next_connection_at = peer[3] ? peer[3].to_i : nil
          
          file.write("#{ip}|#{port}|#{last_seen_at}|#{next_connection_at}")
        end

        file.close

        'Peer list has been saved.'
      end

      def add_known_peers
        list = [
          ['127.0.0.1', '6081', Time.now]
        ]
        write(list)

        list
      end
    end

  end
end