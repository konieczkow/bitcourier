module Bitcourier
  class PeerListFileStorage < PeerListStorage

    def read
      peer_list.peers.clear

      File.read(Bitcourier::CONFIG[:peer_list_path]).lines.map do |line|
        peer_list.peers << Peer.from_a(line.split('|'))
      end
    rescue Errno::ENOENT
    end

    def write
      File.open(Bitcourier::CONFIG[:peer_list_path], 'w') do |file|
        peer_list.peers.each do |peer|
          file.puts peer.to_a.join('|')
        end
      end
    end

  end
end
