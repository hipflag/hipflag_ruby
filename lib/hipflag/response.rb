require 'delegate'
require 'oj'

module Hipflag
  class Response < SimpleDelegator
    alias_method :object, :__getobj__

    def json
      Oj.load(object.body)
    end

    def ok?
      object.status == 200
    end

    def created?
      object.status == 201
    end

    def no_content?
      object.status == 204
    end

    def unauthorized?
      object.status == 401
    end

    def not_found?
      object.status == 404
    end

    def unprocessable?
      object.status == 422
    end

    def server_error?
      object.status >= 500
    end
  end
end
