require 'patron'

module Hipflag
  class Client
    include Client::Flag

    NotFound = Class.new(RuntimeError)
    ServerError = Class.new(RuntimeError)
    Unauthorized = Class.new(RuntimeError)
    UnprocessableEntity = Class.new(RuntimeError)

    BASE_URL = 'https://api.hipflag.com/v1/'
    TIMEOUT = 10

    attr_reader(*Configurable::OPTIONS)

    def initialize(options = {})
      Configurable::OPTIONS.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Hipflag.send(key))
      end

      http_client.base_url = BASE_URL
    end

    private

    def http_client
      @http_client ||= Patron::Session.new do |config|
        config.timeout = TIMEOUT
        config.headers = {
          'Content-Type' => 'application/json',
          'X-Auth-Public' => @public_key,
          'X-Auth-Secret' => @secret_key
        }
      end
    end

    def perform_request(method, url, params = {})
      handle_errors do
        Response.new(http_client.request(method, url, {}, params))
      end
    end

    def handle_errors
      yield.tap do |response|
        if response.unauthorized?
          raise Unauthorized, 'Unauthorized'
        elsif response.unprocessable?
          raise UnprocessableEntity, response.json
        elsif response.server_error?
          raise ServerError, 'Server is not available'
        elsif response.not_found?
          raise NotFound, 'Resource not found'
        end
      end
    end
  end
end
