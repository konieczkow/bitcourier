$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

gem 'minitest' # ensure we are using the gem version

require 'elchat'
require 'minitest/autorun'
require 'simplecov'

SimpleCov.start
