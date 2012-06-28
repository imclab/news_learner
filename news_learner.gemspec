# -*- encoding: utf-8 -*-
require File.expand_path('../lib/news_learner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Cantino"]
  gem.email         = ["andrew@iterationlabs.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "news_learner"
  gem.require_paths = ["lib"]
  gem.version       = NewsLearner::VERSION

  gem.add_development_dependency "rspec"
  gem.add_runtime_dependency 'typhoeus'
end
