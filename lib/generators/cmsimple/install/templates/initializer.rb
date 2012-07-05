Cmsimple.configure do |cmsimple|
  #the parent controller for all the page CRUD activities
  # cmsimple.parent_controller = 'ApplicationController'

  # the parent controller for the page rendering
  # cmsimple.parent_front_controller = 'ApplicationController'

  # the path the templates are loaded from
  # cmsimple.template_path = 'cmsimple/templates'

  # the path carrierwave will use to store image assets
  # self.asset_path = 'uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}'

  # set this to change layouts or pass other params into rendering a template
  # self.template_render_options = {}
end
