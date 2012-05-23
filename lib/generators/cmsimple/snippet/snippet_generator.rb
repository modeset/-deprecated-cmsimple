require 'rails/generators'
require 'rails/generators/named_base'

class Cmsimple::SnippetGenerator < Rails::Generators::NamedBase
  class_option :template_engine
  class_option :test_framework
  class_option :base_snippet_class, :type => :string, :default => "Cell::Rails"
  argument :fields, :type => :array, :default => [:name], :banner => "field field"
  source_root File.expand_path("../templates", __FILE__)

  def create_cell_file
    template 'cell.rb', "#{base_path}_cell.rb"
  end

  def create_view_files
    file = "display.html.#{handler}"
    @path = File.join(base_path, file)
    template file, @path

    @fields = fields
    file = "options.html.#{handler}"
    @path = File.join(base_path, file)
    template file, @path
  end

  # this is gross need to write something that acts like template but just returns the result
  def add_to_snippet_list
    html = ''
    if handler.to_sym == :haml
      html = <<-HTML
%li(data-filter="#{class_name.underscore}, snippet, name")
  %img(alt="#{class_name.humanize} Snippet" data-snippet="#{class_name.underscore}" src="/assets/toolbar/snippets.png")
  %h4>#{class_name.humanize}
  .description A one or two line long description of what this snippet does.</div>
      HTML
    elsif handler.to_sym == :erb
      html = <<-HTML
<li data-filter="#{class_name.underscore}, snippet, name">
  <img alt="#{class_name.humanize} Snippet" data-snippet="#{class_name.underscore}" src="/assets/toolbar/snippets.png">
  <h4>#{class_name.humanize}</h4>
  <div class="description"> A one or two line long description of what this snippet does.</div>
</li>
      HTML
    end
    append_to_file "app/views/cmsimple/_snippet_list.html.#{handler}", html
  end

  private
    def base_path
      File.join('app/cells', class_path, file_name)
    end

    def handler
      options[:template_engine]
    end
end
