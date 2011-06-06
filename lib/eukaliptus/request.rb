require 'rack/request'

# Extend Rack::Request to add some helpers for FB
class Request < ::Rack::Request
  def params
    rack_input = env["rack.input"].read
    @params ||= Rack::Utils.parse_query(rack_input, "&")
  end

  def facebook?
    params["signed_request"].present?
  end
end