module Bitcourier
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
        peers << peer
      end

      save
    end

    def next options = {}
      pool = peers.select(&:can_connect?)
      
      if options[:except]
        except = options[:except]

        pool.delete_if do |p|
          except.include?(p.address)
        end
      end

      pool.sample
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
      store Peer.new(Bitcourier::CONFIG[:peer_seed], Bitcourier::CONFIG[:default_port])
    end

    class Storage

      def initialize list
        @list = list
      end

      def read
        File.read(Bitcourier::CONFIG[:peer_list_path]).lines.map do |line|
          @list.store Peer.from_a(line.split('|'))
        end
      rescue Errno::ENOENT
        return []
      end

      def write
        File.open(Bitcourier::CONFIG[:peer_list_path], 'w') do |file|
          @list.peers.each do |peer|
            file.puts peer.to_a.join('|')
          end
        end
      end
    end
  end
end
