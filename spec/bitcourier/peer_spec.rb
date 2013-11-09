require 'spec_helper'
require 'timecop'

describe Bitcourier::Peer do

  describe '::from_a' do
    it 'returns array representation of the peer' do
      @peer = Bitcourier::Peer.from_a(['1.2.3.4', 5678, 1384002685, 1393687045])

      @peer.ip.must_equal '1.2.3.4'
      @peer.port.must_equal 5678
      @peer.last_seen_at.must_equal Time.utc(2013, 11, 9, 13, 11, 25)
      @peer.next_connection_at.must_equal Time.utc(2014, 3, 1, 15, 17, 25)
    end
  end

  describe '#==' do
    it 'returns true for other Peer with the same address' do
      Bitcourier::Peer.new('1.2.3.4', 5678).must_equal Bitcourier::Peer.new('1.2.3.4', 5678)
    end

    it 'returns false for other Peer with other address' do
      Bitcourier::Peer.new('1.2.3.4', 5678).wont_equal Bitcourier::Peer.new('5.6.7.8', 9999)
    end
  end

  describe '#touch' do
    before do
      @peer = Bitcourier::Peer.new('1.2.3.4', 5678)
      @now  = Time.utc(2013, 11, 9, 12, 39, 47)

      Timecop.freeze(@now)
    end

    describe 'with no arguments' do
      it 'updates last_seen_at to current timestamp' do
        @peer.touch
        @peer.last_seen_at.must_equal @now
      end
    end

    describe 'when last_seen_at is not present' do
      it 'updates last_seen_at to given value' do
        @peer.touch(Time.utc(2013, 11, 9, 13, 03, 11))
        @peer.last_seen_at.must_equal Time.utc(2013, 11, 9, 13, 03, 11)
      end
    end

    describe 'when given value is greater than existing last_seen_at' do
      it 'updates last_seen_at to given value' do
        @peer.last_seen_at = Time.utc(2011, 11, 9, 13, 03, 11)
        @peer.touch(Time.utc(2013, 11, 9, 13, 04, 21))
        @peer.last_seen_at.must_equal Time.utc(2013, 11, 9, 13, 04, 21)
      end
    end

    describe 'when given value is less than or equal to existing last_seen_at' do
      it 'does not update last_seen_at' do
        @peer.last_seen_at = Time.utc(2013, 11, 9, 12, 39, 47)
        @peer.touch(Time.utc(2013, 10, 9, 12, 39, 47))
        @peer.last_seen_at.must_equal Time.utc(2013, 11, 9, 12, 39, 47)
      end
    end
  end

  describe '#update' do
    before do
      @peer1 = Bitcourier::Peer.new('1.2.3.4', 5678, Time.utc(2011, 10, 3, 8, 21, 3), nil)
      @peer2 = Bitcourier::Peer.new('1.2.3.4', 5678, Time.utc(2013, 11, 9, 13, 11, 25), Time.utc(2014, 3, 1, 15, 17, 25))

      @peer1.update(@peer2)
    end

    it 'updates last_seen_at to the value from given peer' do
      @peer1.last_seen_at.must_equal Time.utc(2013, 11, 9, 13, 11, 25)
    end

    it 'updates next_connection_at to the value from given peer' do
      @peer1.next_connection_at.must_equal Time.utc(2014, 3, 1, 15, 17, 25)
    end
  end

  describe '#can_connect?' do
    before do
      @now    = Time.utc(2013, 11, 9, 13, 37, 53)
      @past   = @now - 1
      @future = @now + 1

      Timecop.freeze(@now)
    end

    describe 'with next_connection_at in the past' do
      it 'returns true' do
        Bitcourier::Peer.new('1.2.3.4', 5678, nil, @past).can_connect?.must_equal true
      end
    end

    describe 'with next_connection_at in the present' do
      it 'returns true' do
        Bitcourier::Peer.new('1.2.3.4', 5678, nil, @now).can_connect?.must_equal true
      end
    end

    describe 'with next_connection_at in the future' do
      it 'returns false' do
        Bitcourier::Peer.new('1.2.3.4', 5678, nil, @future).can_connect?.must_equal false
      end
    end
  end

  describe '#retry_in' do
    before do
      @now  = Time.utc(2013, 11, 9, 13, 37, 51)
      @peer = Bitcourier::Peer.new('1.2.3.4', 5678)

      Timecop.freeze(@now)
    end

    it 'sets next_connection_at to given seconds in the future' do
      @peer.retry_in(7)

      @peer.next_connection_at.must_equal Time.utc(2013, 11, 9, 13, 37, 58)
    end
  end

  describe '#to_a' do
    it 'returns array representation of the peer' do
      @peer = Bitcourier::Peer.new('1.2.3.4', 5678, Time.utc(2013, 11, 9, 13, 11, 25), Time.utc(2014, 3, 1, 15, 17, 25))

      @peer.to_a.must_equal ['1.2.3.4', 5678, 1384002685, 1393687045]
    end
  end

  describe '#ip' do
    it 'returns IP address' do
      Bitcourier::Peer.new('1.2.3.4', 5678).ip.must_equal '1.2.3.4'
    end
  end

  describe '#port' do
    it 'returns port' do
      Bitcourier::Peer.new('1.2.3.4', 5678).port.must_equal 5678
    end
  end

end