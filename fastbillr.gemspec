# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fastbillr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Frank Mueller"]
  gem.email         = ["frank@heidjer.info"]
  gem.description   = %q{Ruby Api wrapper for the fastbill.com API}
  gem.summary       = %q{Ruby Api wrapper for the fastbill.com API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fastbillr"
  gem.require_paths = ["lib"]
  gem.version       = Fastbillr::VERSION

  gem.add_dependency "excon", "~> 0.31.0"
  gem.add_dependency "hashie", "~> 2.0.5"
  gem.add_dependency "jruby-openssl" if RUBY_PLATFORM == 'java'

  gem.add_development_dependency "minitest", "~> 5.2.1"
  gem.add_development_dependency "rake", "~> 10.1.1"
end
