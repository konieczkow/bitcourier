require 'spec_helper'

describe Bitcourier::Peer do

  describe '#==' do
    it 'returns true for other Peer with the same address' do
      Bitcourier::Peer.new('1.2.3.4', 5678).must_equal Bitcourier::Peer.new('1.2.3.4', 5678)
    end

    it 'returns false for other Peer with other address' do
      Bitcourier::Peer.new('1.2.3.4', 5678).wont_equal Bitcourier::Peer.new('5.6.7.8', 9999)
    end
  end

end