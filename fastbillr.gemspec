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

  gem.add_dependency "excon"
  gem.add_dependency "json"
  gem.add_dependency "hashie"

  gem.add_development_dependency "minitest", "~> 2.12.1"
  gem.add_development_dependency "fakeweb"
end
