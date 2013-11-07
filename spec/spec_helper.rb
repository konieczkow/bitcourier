$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

gem 'minitest' # ensure we are using the gem version

require 'bitcourier'
require 'minitest/autorun'
require 'json' # https://github.com/colszowka/simplecov/issues/249
