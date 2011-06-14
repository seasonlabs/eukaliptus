require 'rack/request'

# Extend Rack::Request to add some helpers for FB
class Request < ::Rack::Request
  URL_ENCODED = %r{^application/x-www-form-urlencoded}
  JSON_ENCODED = %r{^application/json}

  def params
    @params ||= retrieve_params(env)
  end

  def facebook?
    params['signed_request'].present?
  end

  private
    # Stolen from Goliath
    def retrieve_params(env)
      params = {}
      params.merge!(::Rack::Utils.parse_nested_query(env['QUERY_STRING']))

      if env['rack.input']
        post_params = ::Rack::Utils::Multipart.parse_multipart(env)
        unless post_params
          body = env['rack.input'].read
          env['rack.input'].rewind

          post_params = case(env['CONTENT_TYPE'])
          when URL_ENCODED then
            ::Rack::Utils.parse_nested_query(body)
          when JSON_ENCODED then
            MultiJson.decode(body)
          else
            {}
          end
        end

        params.merge!(post_params)
      end

      params
    end
end