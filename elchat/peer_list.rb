module ElChat
  class PeerList
    attr_accessor :peers

    def initialize
      self.peers = []
      @storage = Storage.new(self)
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

    def next
      peers.select { |p| p.can_connect? }.sample
    end

    def find(peer)
      peers.detect do |i|
        (peer.ip == i.ip) and (peer.port == i.port)
      end
    end

    def save
      @storage.write
    end

    def load
      @storage.read
      seed if peers.size == 0
    end

    def seed
      store Peer.new('127.0.0.1', 6081)
      store Peer.new('127.0.0.1', 6082)
    end

    class Storage
      PATH = "./tmp/peer_list.txt"
      
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
        file = File.open(PATH, 'w') do |file|
          @list.peers.each do |p|
            file.write p.to_a.join('|')
            file.write "\n"
          end
        end
      end
    end
  end
end
