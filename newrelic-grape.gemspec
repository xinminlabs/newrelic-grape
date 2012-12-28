# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic-grape/version'

Gem::Specification.new do |gem|
  gem.name          = "newrelic-grape"
  gem.version       = NewRelic::Grape::VERSION
  gem.authors       = ["Richard Huang"]
  gem.email         = ["flyerhzm@gmail.com"]
  gem.description   = %q{newrelic instrument for grape}
  gem.summary       = %q{newrelic instrument for grape}
  gem.homepage      = "https://github.com/flyerhzm/newrelic-grape"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency(%q<grape>)
  gem.add_runtime_dependency(%q<newrelic_rpm>)
end
