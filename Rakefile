#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/rails_app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

# Cucumber
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  # t.cucumber_opts = "features --format pretty"
end

# Rspec
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/**/*_spec.rb"
end

# Teaspoon
desc "Run the javascript specs"
task :teaspoon => "app:teaspoon"

# Default should run all three
task :default => [:spec, :teaspoon, :cucumber]

