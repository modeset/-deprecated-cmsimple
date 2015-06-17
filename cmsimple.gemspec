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

  s.add_runtime_dependency "railties", ["<4", ">= 3.2.0"]
  s.add_runtime_dependency 'jquery-rails'
  s.add_runtime_dependency "mercury-rails"
  s.add_runtime_dependency "cells", "~> 3.8"
  s.add_runtime_dependency "carrierwave", "~> 0.5.8"

  s.add_runtime_dependency "coffee-script-source", "~> 1.2.0"
  s.add_runtime_dependency "haml"
  s.add_runtime_dependency "haml-rails"
  s.add_runtime_dependency "haml_coffee_assets", "~> 0.9.2"
  s.add_runtime_dependency "dimensions"
  s.add_runtime_dependency "mini_magick"

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec-rails", "~> 2.12.2"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "capybara", "~> 1.1.3"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "timecop"
  s.add_development_dependency "teaspoon"
  s.add_development_dependency "pry-rails"

  # s.add_runtime_dependency "rest-client"
end
