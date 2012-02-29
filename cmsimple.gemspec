# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cmsimple/version"

Gem::Specification.new do |s|
  s.name        = "cmsimple"
  s.version     = Cmsimple::VERSION
  s.authors     = ["Gabe Varela", "Jay Zeschin", "Matt Kitt"]
  s.email       = ["info@modeset.com"]
  s.homepage    = ""
  s.summary     = %q{A simple CMS based on the Mercury editor}
  s.description = %q{A simple CMS based on the Mercury editor}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rails", "~> 3.2.1"
  s.add_runtime_dependency "haml-rails"
  s.add_runtime_dependency 'jquery-rails'
  s.add_runtime_dependency "formtastic"
  s.add_runtime_dependency "mercury-rails"
  s.add_runtime_dependency "cells", "~> 3.8"
  s.add_runtime_dependency "spine-rails", "~> 0.1"
  s.add_runtime_dependency "haml_coffee_assets"


  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
