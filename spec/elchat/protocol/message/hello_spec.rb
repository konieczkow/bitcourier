require_relative '../../../spec_helper'

describe ElChat::Protocol::Message::Hello do
  before do
    @hello       = ElChat::Protocol::Message::Hello.new
    @hello_bytes = "{\x00\x11\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
  end

  it 'initiates with default version number' do
    @hello.protocol_version.must_equal ElChat::Protocol::Message::Hello::PROTOCOL_VERSION
  end

  describe '#payload' do
    it 'returns payload bytes' do
      @hello.protocol_version = 123
      @hello.port             = 17
      @hello.nonce            = 2**64 - 1

      @hello.payload.must_equal @hello_bytes
    end
  end

  describe '#extract' do
    it 'extracts payload bytes to object values' do
      @hello.extract @hello_bytes

      @hello.protocol_version.must_equal 123
      @hello.port.must_equal 17
      @hello.nonce.must_equal 2**64 - 1
    end
  end

end