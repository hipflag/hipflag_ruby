lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hipflag/version'

Gem::Specification.new do |spec|
  spec.name = 'hipflag'
  spec.version = Hipflag::VERSION
  spec.authors = ['Hipflag']
  spec.email = ['info@hipflag.com']

  spec.summary = %q{Ruby client for interacting with Hipflag API}
  spec.description = %q{This gem is a Ruby client for interacting with Hipflag API. Hipflag is a tool that allows to control and roll out new product features with flags}
  spec.homepage = 'https://github.com/hipflag/hipflag_ruby'
  spec.license = 'MIT'

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.bindir = 'bin'
  spec.executables  = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'patron', '~> 0.13.1'
  spec.add_dependency 'oj', '~> 3.7.12'
  spec.add_dependency 'zeitwerk', '~> 2.1.6'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 12.3'
end
