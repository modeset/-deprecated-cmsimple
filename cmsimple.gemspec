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
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rails", '~> 4.0'
  s.add_runtime_dependency 'jquery-rails', '>= 2.0.2'
  s.add_runtime_dependency 'mercury-rails'
  s.add_runtime_dependency 'responders'
  s.add_runtime_dependency "cells"
  s.add_runtime_dependency "carrierwave"

  s.add_runtime_dependency "haml_coffee_assets", "~> 0.9.2"
  s.add_runtime_dependency "dimensions"
  s.add_runtime_dependency "mini_magick"
  s.add_runtime_dependency "rest-client"
end
