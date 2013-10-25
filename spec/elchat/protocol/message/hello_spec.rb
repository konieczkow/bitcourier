require_relative '../../../spec_helper'

describe ElChat::Protocol::Message::Hello do
  before do
    @hello = ElChat::Protocol::Message::Hello.new
  end

  it 'initiates with default version number' do
    @hello.protocol_version.must_equal ElChat::Protocol::Message::Hello::PROTOCOL_VERSION
  end

  describe '#payload' do
    it 'returns payload bytes' do
      @hello.protocol_version = 123
      @hello.port             = 17
      @hello.nonce            = 18446744073709551616

      @hello.payload.must_equal "{\x00\x11\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    end
  end

  describe '#extract' do
    it 'extracts payload bytes to object values' do
      @hello.extract("\x94&\xE4\a\x12!\x9A\x00\x00\x00\x00\x00")

      @hello.protocol_version.must_equal 9876
      @hello.port.must_equal 2020
      @hello.nonce.must_equal 10101010
    end
  end

end