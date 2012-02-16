module Cmsimple
  class SnippetsController < Cmsimple.configuration.parent_controller.constantize

    def index
    end

    def preview
      @snippet = Cmsimple::Snippet.new params[:name], options: params[:snippet]
      render text: render_cell(params[:name], :preview, @snippet)
    end

    def options
      @snippet = Cmsimple::Snippet.new params[:name], options: params[:snippet]
      render text: render_cell(params[:name], :options, @snippet)
    end

  end
end
