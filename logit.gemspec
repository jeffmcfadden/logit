# coding: utf-8 #

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logit/version'

Gem::Specification.new do |spec|
  spec.name          = "logit"
  spec.version       = Logit::VERSION
  spec.authors       = ["jeffmcfadden"]
  spec.email         = ["jeff@forgeapps.com"]

  spec.summary       = %q{Super basic data logging tool. Logs numeric values to a file.}
  spec.description   = %q{Works well with the graphit gem.}
  spec.homepage      = "https://github.com/jeffmcfadden/logit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
