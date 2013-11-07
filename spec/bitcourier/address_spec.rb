require 'spec_helper'

describe Bitcourier::Address do

  it 'requires IP to be present' do
    proc { Bitcourier::Address.new(nil, 5678) }.must_raise ArgumentError
  end

  it 'requires port to be present' do
    proc { Bitcourier::Address.new('1.2.3.4', nil) }.must_raise ArgumentError
  end

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

  describe '#to_s' do
    it 'returns formatted host:port address' do
      Bitcourier::Address.new('1.2.3.4', 5678).to_s.must_equal '1.2.3.4:5678'
    end
  end

  describe '#to_a' do
    it 'returns array representation of the address' do
      Bitcourier::Address.new('1.2.3.4', 5678).to_a.must_equal ['1.2.3.4', 5678]
    end
  end

end