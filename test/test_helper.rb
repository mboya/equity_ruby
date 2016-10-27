$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equity_ruby'
require 'webmock/minitest'
require 'minitest/autorun'
require 'pry'

WebMock.disable_net_connect!

