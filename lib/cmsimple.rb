require "cmsimple/version"
require 'rails'
require 'haml-rails'


module Cmsimple
  class Configuration
    def initialize
      self.parent_controller = 'ApplicationController'
    end
    attr_accessor :parent_controller
  end

  class << self
    attr_accessor :configuration

    # Configure CMSimple
    #
    def configure
      self.configuration ||= Configuration.new
      yield self.configuration
    end
  end
end

require 'cmsimple/rails'
require 'cmsimple/template_responder'

