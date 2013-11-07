require 'spec_helper'

describe Bitcourier::Address do

  describe '#==' do
    it 'returns true for other Address with the same IP and port' do
      Bitcourier::Address.new('1.2.3.4', 5678).must_equal Bitcourier::Address.new('1.2.3.4', 5678)
    end

    it 'returns false for other Address with the same IP and other port' do
      Bitcourier::Address.new('1.2.3.4', 5678).wont_equal Bitcourier::Address.new('1.2.3.4', 9999)
    end

    it 'returns false for other Address with the other IP and same port' do
      Bitcourier::Address.new('1.2.3.4', 5678).wont_equal Bitcourier::Address.new('4.3.2.1', 5678)
    end

    it 'returns false for other Address with the other IP and other port' do
      Bitcourier::Address.new('1.2.3.4', 5678).wont_equal Bitcourier::Address.new('4.3.2.1', 9999)
    end
  end

end