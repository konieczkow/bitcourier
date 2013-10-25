$LOAD_PATH.unshift File.expand_path('../../elchat', __FILE__)

gem 'minitest' # ensure we are using the gem version

require_relative '../elchat'
require 'minitest/autorun'
require 'simplecov'

SimpleCov.start
