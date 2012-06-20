
module Cmsimple
  module RegionsHelper
    def resource_regions
      @page.regions
    end

    def region_content(region)
      region.render_snippets do |snippet|
        render_snippet(snippet)
      end
      raw region
    end

    def render_region(region_name, options={}, &block)
      content = region_content(resource_regions.send(region_name))

      if content.blank? && block_given?
        content = capture(&block)
      end

      if options[:tag]
        html_options = options[:html].presence || {}
        html_options = html_options.merge(:id => region_name, :'data-mercury' => options[:region_type] || 'full')

        content = content_tag options[:tag], content, html_options
      end

      raw content
    end

    def render_snippet(snippet)
      render_cell snippet.name, :display, snippet
    end
  end
end

