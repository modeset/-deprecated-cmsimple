module Cmsimple
  class PagesController < Cmsimple.configuration.parent_controller.constantize
    self.responder = Cmsimple.configuration.template_strategy
    respond_to :html

    def show
      @page = Page.find_by_path!("/#{params[:page]}")
      respond_with @page
    end
  end
end
