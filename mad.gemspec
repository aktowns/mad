# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mad/version'

Gem::Specification.new do |spec|
  spec.name          = "mad"
  spec.version       = Mad::VERSION
  spec.authors       = ["Ashley Towns"]
  spec.email         = ["ashleyis@me.com"]
  spec.summary       = %q{A tiny ruby command line editor}
  spec.description   = %q{A ruby command line text editor using termbox and rouge}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "ffi", "~> 1.9"
  spec.add_dependency "rouge", "~> 1.7"
end
