module ElChat
  class PeerList
    attr_reader :peers

    def initialize
      @peers   = []
      @storage = Storage.new(self)

      load
    end

    def store(peer)
      if existing = find(peer)
        existing.update(peer)
      else
        puts "New peer: #{peer.ip}:#{peer.port}"
        peers << peer
      end

      save
    end

    def next
      peers.select(&:can_connect?).sample
    end

    private

    attr_reader :storage

    def find(peer)
      peers.detect { |existing| existing.same?(peer) }
    end

    def save
      storage.write
    end

    def load
      storage.read

      seed if peers.size == 0
    end

    def seed
      store Peer.new('127.0.0.1', 6081)
      store Peer.new('127.0.0.1', 6082)
    end

    class Storage
      PATH = './tmp/peer_list.txt'
      
      def initialize list
        @list = list
      end

      def read
        File.read(PATH).lines.map do |line|
          @list.store Peer.from_a(line.split('|'))
        end
      rescue Errno::ENOENT
        return []
      end

      def write
        File.open(PATH, 'w') do |file|
          @list.peers.each do |peer|
            file.puts peer.to_a.join('|')
          end
        end
      end
    end
  end
end
