module Cmsimple
  class Configuration
    def initialize
      # the parent controller for the front controller
      self.parent_front_controller = 'ApplicationController'
      # the parent controller for all CRUD controllers
      self.parent_controller = 'ApplicationController'
      # where the templates are located in the project
      self.template_path = 'cmsimple/templates'
      # set a template strategy (i.e. if you wanted to build a db backed template system)
      self.template_strategy = :basic
      # the path carrierwave will use to store image assets
      self.asset_path = 'uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}'
      # the library to use for processing images in carrierwave (rmagick or mini_magick)
      self.image_processor = :mini_magick
      # stylesheets to be included in the editor layout page
      self.editor_stylesheets = ['cmsimple']
      # javascripts to be included in the editor layout page
      self.editor_javascripts = ['cmsimple']
      # set this to change layouts or pass other params into rendering a template
      self.template_render_options = {}
    end

    attr_accessor :parent_controller,
                  :parent_front_controller,
                  :template_path,
                  :asset_path,
                  :image_processor,
                  :editor_stylesheets,
                  :editor_javascripts,
                  :template_render_options

    attr_writer   :template_strategy

    def template_strategy
      case @template_strategy
      when :basic
        Cmsimple::TemplateResponder
      else
        @template_strategy.constantize
      end
    end

    def image_processor_mixin
      case @image_processor
      when :rmagick
        CarrierWave::RMagick
      else
        CarrierWave::MiniMagick
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
