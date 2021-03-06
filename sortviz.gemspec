# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sortviz/version'

Gem::Specification.new do |spec|
  spec.name          = "sortviz"
  spec.version       = Sortviz::VERSION
  spec.authors       = ["Hady Ahmed"]
  spec.email         = ["me@hadyahmed.com"]

  spec.summary       = %q{Terminal based sorting algorithms visualizer}
  spec.description   = %q{Visualize sorting algorithms with Ruby and Curses lib}
  spec.homepage      = "https://github.com/l0gicpath/sortviz"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "curses", "~> 1.0.2"
end
