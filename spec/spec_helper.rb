$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if RUBY_VERSION < '1.9'
  class String
    def force_encoding(encoding)
      self
    end
  end
end

gem 'minitest' # ensure we are using the gem version

require 'elchat'
require 'minitest/autorun'
require 'simplecov'

SimpleCov.start
