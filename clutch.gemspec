# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clutch/version'

Gem::Specification.new do |spec|
  spec.name          = "clutch-client"
  spec.version       = Clutch::VERSION
  spec.authors       = [""]
  spec.email         = [""]

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.15.1"
  spec.add_dependency "faraday_middleware", "~> 0.12.2"
  spec.add_dependency "hashie", "~> 3.5"

  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "pronto", "~> 0.7"
  spec.add_development_dependency "pronto-rubocop", "~> 0.7"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.3"
end
