module Cmsimple
  class TemplateResponder < ActionController::Responder
    def default_render
      if controller.action_name == 'show'
        controller.render File.join Cmsimple.configuration.template_path, (@resource.template.presence || 'default')
      else
        super
      end
    end
  end
end
