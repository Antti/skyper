# -*- encoding: utf-8 -*-
require File.expand_path('../lib/skyper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andriy Dmytrenko"]
  gem.email         = ["refresh.xss@gmail.com"]
  gem.description   = %q{Ruby interface to Skype on Mac OS X}
  gem.summary       = %q{Ruby interface to Skype on Mac OS X}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "skyper"
  gem.require_paths = ["lib"]
  gem.version       = Skyper::VERSION
  gem.add_runtime_dependency 'rb-appscript', '>=0.3.0'
end
