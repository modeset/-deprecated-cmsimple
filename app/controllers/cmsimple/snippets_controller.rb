module Cmsimple
  class SnippetsController < Cmsimple.configuration.parent_controller.constantize

    def index
      render :index, layout: false
    end

    def preview
      @snippet = Cmsimple::Snippet.new params[:name], options: params[:snippet]
      render text: render_cell(params[:name], :preview, @snippet)
    end

    def options
      # the options prefix is to handle legacy snippets mercury
      # changed how it serializes snippets
      @options = params[:options][:snippet] if params[:options]
      @options ||= params[:snippet]
      @snippet = Cmsimple::Snippet.new params[:name], options: @options
      render text: render_cell(params[:name], :options, @snippet)
    end

  end
end
