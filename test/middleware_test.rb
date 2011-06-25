require 'test_helper'

class TestEukaliptus < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Eukaliptus::Middleware.new
  end
      
  def test_eukaliptus_headers
    skip "Test P3p header"
  end
  
  def test_rack_request_params
    get '/cookie_fix'
    assert_equal "http://example.org/cookie_fix", last_request.url
  end
end
