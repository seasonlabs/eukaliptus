module Eukaliptus
  class Middleware
    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      @request = Request.new(env)

      # Catch and convert POST from facebook
      if @request.facebook?
        env["facebook.original_method"] = env["REQUEST_METHOD"]
        env["REQUEST_METHOD"] = 'GET'
      end

      status, headers, body = @app.call(env)
      @response = Rack::Response.new body, status, headers

      # Fixes IE security bug
      @response.header["P3P"] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'

      if env['PATH_INFO'] == '/cookie_fix'
        cookie_fix(env)
      else
        @response.finish
      end
    end

    # Get POST params and process it to build up the cookie for FB
    # authentication. Then prepare the response for redirection and
    # breaks the request workflow setting the cookie at the same time.
    # This way Safari and other browsers with extra iframe security
    # gets the cookie set too.
    def cookie_fix(env)
      params = @request.params
      
      if params['_session_id']
        session = ActiveSupport::JSON.decode(params['_session_id'])

        unless (@request.cookies['fbs_' + Facebook::APP_ID.to_s].present?)
          session = session.map { |key, value| key.to_s + "=" + value.to_s }.join("&")
          @response.set_cookie('fbs_' + Facebook::APP_ID.to_s, session)
        end
      end

      @response.headers.delete "Content-Type"
      @response.headers.delete "Content-Length"
      @response.headers.delete "X-Cascade"

      if defined?(OmniAuth) and defined?(Devise)
        mappings = Devise.mappings[:user]

        if mappings.controllers.has_key? :omniauth_callbacks
          path = [mappings.path, 'auth', :facebook.to_s, 'callback'].join('/')
          @response.redirect(path  + "?redirect_to=#{params['redirect_to']}")
        else
          @response.redirect('/' + "?redirect_to=#{params['redirect_to']}")
        end
      else
        @response.redirect((params['redirect_to'] ? params['redirect_to'] : '/'))
      end

      [302, @response.headers, 'Cookie Setted']
    end
  end
end