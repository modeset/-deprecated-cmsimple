module Cmsimple
  class TemplateResponder < ActionController::Responder
    def default_render
      controller.render File.join Cmsimple.configuration.template_path, (@resource.template.presence || 'default')
    end
  end
end
