require "cmsimple/version"
require 'rails'
require 'haml-rails'
require 'formtastic'
require 'mercury-rails'
require 'cells'

module Cmsimple
  class Configuration
    def initialize
      self.parent_controller = 'ApplicationController'
      self.template_strategy = :basic
    end

    attr_accessor :parent_controller
    attr_writer :template_strategy

    def template_strategy
      case @template_strategy
      when :basic
        Cmsimple::TemplateResponder
      else
        @template_strategy.constantize
      end
    end
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
require 'cmsimple/regions_proxy'

