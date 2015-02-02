# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mad/version'

Gem::Specification.new do |spec|
  spec.name          = 'mad'
  spec.version       = Mad::VERSION
  spec.authors       = ['Ashley Towns']
  spec.email         = ['ashleyis@me.com']
  spec.summary       = 'A tiny ruby command line editor'
  spec.description   = 'A ruby command line text editor using termbox and rouge'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.8.7'
  spec.add_development_dependency 'rubocop', '~> 0.28.0'
  spec.add_development_dependency 'cane', '~> 2.6.2'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'simplecov', '~> 0.9.1'
  spec.add_development_dependency 'pry', '~> 0.10.1'

  spec.add_dependency 'termbox-ffi', '~> 0.0.1'
  spec.add_dependency 'rouge', '~> 1.7'
  spec.add_dependency 'github-linguist', '~> 4.3.0'
end
