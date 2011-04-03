module Eukaliptus
  class Middleware
    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      @request = Rack::Request.new(env)
      status, headers, body = @app.call(env)
      @response = Rack::Response.new body, status, headers

      @response.header["P3P"] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'

      cookie_fix(env)# if env['PATH_INFO'] == '/cookie_fix'

      @response.finish
    end

    def cookie_fix(env)
      rack_input = env["rack.input"].read
      params = Rack::Utils.parse_query(rack_input, "&")

      if params['_session_id']
        session = ActiveSupport::JSON.decode(params['_session_id'])
      end

      unless (@request.cookies['fbs_' + Facebook::APP_ID.to_s].present?)
        session = session.map { |key, value| key.to_s + "=" + value.to_s }.join("&")
        cookies['fbs_' + Facebook::APP_ID.to_s] = session
      end
      redirect_to params[:redirect_to] and return

      @response.set_cookie("foo", {:value => "bar"})


      @response.status = 200
    end
  end
end