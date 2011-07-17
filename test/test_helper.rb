ENV["RAILS_ENV"] = "test"

gem 'minitest'
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/spec'
require 'minitest/pride'
require 'rack/test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rails'
require 'eukaliptus'
require 'eukaliptus/view_helpers/facebook_helpers'

module ::Facebook
  APP_ID = '123456' 
end

MiniTest::Unit.autorun

