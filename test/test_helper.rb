ENV["RAILS_ENV"] = "test"

require 'minitest/unit'
require 'minitest/spec'
require 'rack/test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rails'
require 'eukaliptus'

MiniTest::Unit.autorun

