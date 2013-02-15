require 'error/page_not_found'
module Cmsimple

  class PageResponder
    def initialize(controller)
      @controller  = controller
      @request     = @controller.request
      @params      = @request.params
      @page        = @controller.current_page
    end

    def respond
      @controller.respond_with page_for_context
    end

    def page_for_context
      raise Cmsimple::Error::PageNotFound unless current_page_is_viewable?

      return published_context? ||
               version_context? ||
               draft_context?
    end

    def published_context?
      unless is_currently_editable?
        return @page if @page.as_published!
      end
    end

    def version_context?
      if @params[:version].present?
        return @page if @page.at_version!(@params[:version])
      end
    end

    def draft_context?
      @page
    end

    def current_page_is_viewable?
      is_currently_editable? || @page.published?
    end

    def is_currently_editable?
      @controller.in_editor_iframe?
    end
  end
end
