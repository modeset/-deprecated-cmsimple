# This file allows you to override various Teaspoon configuration directives when running from the command line. It is not
# required from within the Rails environment, so overriding directives that have been defined within the initializer
# is not possible.
#
# Set RAILS_ROOT and load the environment.
ENV["RAILS_ROOT"] = File.expand_path("../../", __FILE__)
require File.expand_path("../../config/environment", __FILE__)

# Provide default configuration.
#
# You can override various configuration directives defined here by using arguments with the teaspoon command.
#
# teaspoon --driver=selenium --suppress-log
# rake teaspoon DRIVER=selenium SUPPRESS_LOG=false
Teaspoon.configure do |config|
  config.mount_at = "/teaspoon"
  config.root = nil
  config.asset_paths = ["spec/javascripts", "spec/javascripts/stylesheets"]
  config.fixture_paths = %w(spec javascripts fixtures)
  config.suite do |suite|
    suite.matcher = "{spec/javascripts,app/assets}/**/*_spec.{js,js.coffee,coffee}"
    suite.helper = "spec_helper"
    suite.stylesheets = ["teaspoon"]
    suite.no_coverage = [%r{/lib/ruby/gems/}, %r{/vendor/assets/}, %r{/support/}, %r{/(.+)_helper.}]
  end
  # Driver
  config.driver = 'phantomjs'
  #config.driver         = "phantomjs" # available: phantomjs, selenium

  # Behaviors
  #config.server_timeout = 20 # timeout for starting the server
  #config.fail_fast      = true # abort after the first failing suite

  # Output
  #config.formatters     = "dot" # available: dot, tap_y, swayze_or_oprah
  #config.suppress_log   = false # suppress logs coming from console[log/error/debug]
  #config.color          = true
end
