
module Cmsimple
  module RegionsHelper
    def region_content(region)
      region.render_snippets do |snippet|
        render_snippet(snippet)
      end
      raw region
    end

    def render_region(region_name, options={}, &block)
      content = region_content(@page.regions.send(region_name))

      if content.blank? && block_given?
        content = capture(&block)
      end

      if options[:tag]
        html_class = 'mercury-region '
        html_options = options[:html].presence || {}
        html_class << html_options[:class] if html_options[:class]
        html_options = html_options.merge(:id => region_name, :'data-type' => 'editable', :class => html_class)

        content = content_tag options[:tag], content, html_options
      end

      raw content
    end

    def render_snippet(snippet)
      render_cell snippet.name, :display, snippet
    end
  end
end

