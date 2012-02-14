module Cmsimple
  class PagesController < Cmsimple.configuration.parent_controller.constantize
    self.responder = Cmsimple.configuration.template_strategy
    helper Cmsimple::RegionsHelper

    respond_to :html, :json

    def update_content
      @page = Page.find_by_path!("/#{params[:page]}")
      @page.update_content(params[:content])
      respond_with @page, :location => @page.path
    end

    def show
      @page = Page.find_by_path!("/#{params[:page]}")
      respond_with @page
    end
  end
end
