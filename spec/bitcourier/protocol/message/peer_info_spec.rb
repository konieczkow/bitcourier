require 'spec_helper'

describe Bitcourier::Protocol::Message::PeerInfo do
  before do
    @peer_info       = Bitcourier::Protocol::Message::PeerInfo.new
    @peer_info_bytes = "\x01\x02\x03\x04\xFF\xFF\xAF5\xA24".force_encoding(Encoding::BINARY)
  end

  describe '#payload' do
    it 'returns payload bytes' do
      @peer_info.ip           = '1.2.3.4'
      @peer_info.port         = 65535
      @peer_info.last_seen_at = Time.utc(1997, 12, 25, 10, 30, 7)

      @peer_info.payload.must_equal @peer_info_bytes
    end
  end

  describe '#extract' do
    it 'extracts payload bytes to object values' do
      @peer_info.extract @peer_info_bytes

      @peer_info.ip.must_equal '1.2.3.4'
      @peer_info.port.must_equal 65535
      @peer_info.last_seen_at.must_equal Time.utc(1997, 12, 25, 10, 30, 7)
    end
  end

end