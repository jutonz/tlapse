# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tlapse/version"

Gem::Specification.new do |spec|
  spec.name          = "tlapse"
  spec.version       = Tlapse::VERSION
  spec.authors       = ["Justin Toniazzo"]
  spec.email         = ["jutonz@hey.com"]

  spec.summary       = "Automated time lapse photography via gphoto2"
  spec.homepage      = "https://github.com/jutonz/tlapse"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = %w(tlapse)
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 8.2"
  spec.add_development_dependency "timecop", "~> 0.8"
  spec.add_development_dependency "simplecov", "~> 0.15"

  spec.add_dependency "activesupport", "~> 5"
  spec.add_dependency "RubySunrise", "~> 0.3"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "rainbow", "~> 3"
end
