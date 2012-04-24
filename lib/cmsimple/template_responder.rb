module Cmsimple
  class TemplateResponder < ActionController::Responder
    def default_render
      if controller.action_name == 'show'
        template = File.join Cmsimple.configuration.template_path, (@resource.template.presence || 'default')
        controller.render template, @resource.template_render_options
      else
        super
      end
    end
  end
end
