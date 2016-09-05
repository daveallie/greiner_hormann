# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'greiner_hormann/version'

Gem::Specification.new do |spec|
  spec.name          = "greiner_hormann"
  spec.version       = GreinerHormann::VERSION
  spec.authors       = ["Dave Allie"]
  spec.email         = ["dave@daveallie.com"]

  spec.summary       = %q{Polygon clipping using Greiner-Hormann algorithm.}
  spec.description   = %q{Polygon clipping using Greiner-Hormann algorithm.}
  spec.homepage      = "https://github.com/daveallie/greiner_hormann"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
