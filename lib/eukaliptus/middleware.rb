module Eukaliptus
  class Middleware
    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      @request = Rack::Request.new(env)
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

    def cookie_fix(env)
      rack_input = env["rack.input"].read
      params = Rack::Utils.parse_query(rack_input, "&")

      if params['_session_id']
        session = ActiveSupport::JSON.decode(params['_session_id'])

        unless (@request.cookies['fbs_' + Facebook::APP_ID.to_s].present?)
          session = session.map { |key, value| key.to_s + "=" + value.to_s }.join("&")
          @response.set_cookie('fbs_' + Facebook::APP_ID.to_s, session)
        end
      end

      [302, {'Location' => (params['redirect_to'] ? params['redirect_to'] : '/')}, 'Cookie Setted']
    end
  end
end