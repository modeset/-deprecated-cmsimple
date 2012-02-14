module Cmsimple
  class TemplateResponder < ActionController::Responder
    def default_render
      controller.render "cmsimple/templates/#{@resource.template.presence || 'default'}"
    end
  end
end
