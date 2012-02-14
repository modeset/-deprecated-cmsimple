
module Cmsimple
  module RegionsHelper
    def region(region)
      region.render_snippets do |snippet|
        render_snippet(snippet)
      end
      raw region
    end

    def render_snippet(snippet)
      render_cell snippet.name, :display, snippet
    end
  end
end

