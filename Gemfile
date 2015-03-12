source 'https://rubygems.org'

gem 'pg'
# Specify your gem's dependencies in ..gemspec
gemspec

gem 'multi_json', '>= 1.3.4'
gem 'railties', '~> 4.0.0'
gem 'mercury-rails', github: "jejacks0n/mercury"
gem 'responders'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "timecop"
  gem "teaspoon"
end

group :test do
  gem "cucumber-rails", require: false
  gem 'selenium-webdriver'
end
