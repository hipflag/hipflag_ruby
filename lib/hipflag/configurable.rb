module Hipflag
  module Configurable
    OPTIONS = %i[public_key secret_key].freeze

    attr_accessor(*OPTIONS)

    def configure
      yield self
    end
  end
end
