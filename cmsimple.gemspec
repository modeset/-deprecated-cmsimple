# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cmsimple/version"

Gem::Specification.new do |s|
  s.name        = "cmsimple"
  s.version     = Cmsimple::VERSION
  s.authors     = ["Gabe Varela"]
  s.email       = ["gvarela@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rails"
  s.add_runtime_dependency "haml-rails"
  s.add_runtime_dependency 'jquery-rails'
  s.add_runtime_dependency "formtastic"
  s.add_runtime_dependency "will_paginate"


  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
