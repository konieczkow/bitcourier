require 'bitcourier/config'
require 'bitcourier/protocol'
require 'bitcourier/network'
require 'bitcourier/address'
require 'bitcourier/address_array'
require 'bitcourier/node'
require 'bitcourier/node_manager'
require 'bitcourier/daemon'
require 'bitcourier/peer'
require 'bitcourier/peer_list'
require 'bitcourier/version'

module Bitcourier
end

Bitcourier::CONFIG = Bitcourier::Config.new.config
