# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'changes_since/version'

Gem::Specification.new do |spec|
  spec.name          = "changes_since"
  spec.version       = ChangesSince::VERSION
  spec.authors       = ["Ashwin Hegde"]
  spec.email         = ["ahegde@zendesk.com"]
  spec.summary       = "Git Changes since a tag"
  spec.description   = "Shows you all the merged pull requests since a certain git tag in a nice format"
  spec.homepage      = "http://rubygems.org/gems/changes_since"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '10.1.1'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'shoulda'
  spec.add_dependency "git"
end
