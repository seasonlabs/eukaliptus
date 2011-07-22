require 'test_helper'

class MiddlewareTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Eukaliptus::Middleware.new(lambda { |env| [200, {}, "Coolness"] })
  end
      
  def test_respond_p3p_headers
    get '/cookie_fix'
    assert_equal last_response["P3P"], 'CP="HONK HONK! http://graeme.per.ly/p3p-policies-are-a-joke"'
  end
  
  def test_should_redirect
    get '/cookie_fix'
    assert last_response.redirect?
  end

  def test_should_redirect_to_param
    get '/cookie_fix', :redirect_to => '/somewhere'
    assert_equal last_response['Location'], '/somewhere'
  end

  def test_should_respond_with_cookie
    get '/cookie_fix', :redirect_to => '/'

    assert_instance_of String, last_response.body
    assert_equal 'Cookie Setted', last_response.body
  end
end
