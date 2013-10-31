require 'spec_helper'

describe Bitcourier::Config do
  before do
    Bitcourier::Config::DEFAULT_CONFIG = {
        first_config: true,
        second_config: [1, 2, 3]
    }
    @config = Bitcourier::Config.new
  end

  describe 'when no config file available' do
    it 'uses default config' do
      @config.config.must_equal Bitcourier::Config::DEFAULT_CONFIG
    end
  end

end