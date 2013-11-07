require 'spec_helper'

describe Bitcourier::Protocol::Message::Base do

  describe '::unpack' do

    describe 'given GetPeerList packet bytes' do
      it 'returns GetPeerList message object' do
        get_peer_list_bytes = "4\x12\x02\x00\x00\x00".force_encoding(Encoding::BINARY)
        get_peer_list       = Bitcourier::Protocol::Message::Base.unpack(get_peer_list_bytes)

        get_peer_list.must_be_instance_of Bitcourier::Protocol::Message::GetPeerList
      end
    end

    describe 'given Hello packet bytes' do
      it 'returns Hello message object' do
        hello_bytes = "4\x12\x01\x00\f\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".force_encoding(Encoding::BINARY)
        hello       = Bitcourier::Protocol::Message::Base.unpack(hello_bytes)

        hello.must_be_instance_of Bitcourier::Protocol::Message::Hello
      end
    end

    describe 'given PeerInfo packet bytes' do
      it 'returns PeerInfo message object' do
        peer_info_bytes = "4\x12\x03\x00\n\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".force_encoding(Encoding::BINARY)
        peer_info       = Bitcourier::Protocol::Message::Base.unpack(peer_info_bytes)

        peer_info.must_be_instance_of Bitcourier::Protocol::Message::PeerInfo
      end
    end

    describe 'given unknown packet bytes' do
      it 'returns nil' do
        unknown_bytes = "4\x12\xFF\x00\x00\x00".force_encoding(Encoding::BINARY)
        unknown       = Bitcourier::Protocol::Message::Base.unpack(unknown_bytes)

        unknown.must_be_nil
      end
    end

  end

end