module Cmsimple
  class TemplateResolver
    def self.all
      templates = []
      ActionController::Base.view_paths.each do |path|
        template_directory = File.join(path, Cmsimple.configuration.template_path)
        Dir[File.join(template_directory, "*.*")].each do |file|
          templates << File.basename(file).split('.').first
        end
      end
      templates.uniq
    end
  end
end
