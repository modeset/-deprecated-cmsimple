require 'rails/generators'

class Cmsimple::InstallGenerator < Rails::Generators::Base
  class_option :template_engine
  class_option :test_framework
  source_root File.expand_path("../templates", __FILE__)

  def create_initializer
    template 'initializer.rb', 'config/initializers/cmsimple.rb'
  end

  def add_routes
    route %Q{#this route should always be last
  mount Cmsimple::Engine => '/'}
  end

  def create_default_template
    file = "default.html.#{handler}"
    template file, "app/views/cmsimple/templates/#{file}"
  end

  def create_snippets_list
    create_file "app/views/cmsimple/_snippet_list.html.#{handler}", "Run the snippet generator to add a snippet"
  end

  def add_to_seeds_file
   seed = <<-SEED
unless Cmsimple::Page.where(is_root: true).first
  page = Cmsimple::Page.create is_root: true, title: 'Home', template: 'default'
  page.publish!
end
   SEED
   append_to_file 'db/seeds.rb', seed
  end

  def install_migrations
    rake('cmsimple:install:migrations')
    rake('db:migrate')
    rake('db:seed')
  end

  private
  def handler
    options[:template_engine]
  end
end
