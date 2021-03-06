# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitcourier/version'

Gem::Specification.new do |spec|
  spec.name          = 'bitcourier'
  spec.version       = Bitcourier::VERSION
  spec.authors       = ['EL Passion']
  spec.email         = ['account@elpassion.com']
  spec.description   = %q{Decentralized and trustless communication protocol used to anonymously send encrypted messages via peer-to-peer network}
  spec.summary       = %q{Decentralized and trustless communication protocol used to anonymously send encrypted messages via peer-to-peer network}
  spec.homepage      = 'https://github.com/elpassion/bitcourier'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.18.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'minitest', '>= 5.0.8'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov', '>= 0.7.1'
  spec.add_development_dependency 'timecop', '~> 0.6.3'
end
