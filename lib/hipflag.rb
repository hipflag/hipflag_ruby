require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.setup
loader.reload

module Hipflag
  class << self
    include Hipflag::Configurable
  end
end
