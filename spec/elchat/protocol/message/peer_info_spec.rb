require_relative '../../../spec_helper'

describe ElChat::Protocol::Message::PeerInfo do
  before do
    @peer_info = ElChat::Protocol::Message::PeerInfo.new
  end

  describe '#payload' do
    it 'returns payload bytes' do
      @peer_info.ip           = '1.2.3.4'
      @peer_info.port         = 5678
      @peer_info.last_seen_at = Time.new(2013, 10, 25, 23, 46, 27)

      @peer_info.payload.must_equal "\x01\x02\x03\x04.\x16\xB3\xE6jR"
    end
  end

  describe '#extract' do
    it 'extracts payload bytes to object values' do
      @peer_info.extract("\x00\x00\x00\x00\xFF\xFF\xAF5\xA24")

      @peer_info.ip.must_equal '0.0.0.0'
      @peer_info.port.must_equal 65535
      @peer_info.last_seen_at.must_equal Time.new(1997, 12, 25, 11, 30, 7)
    end
  end

end