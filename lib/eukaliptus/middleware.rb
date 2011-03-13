module Eukaliptus
  class Middleware
    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      @req = Rack::Request.new(env)
      @app.call(env)
    end
  end
end