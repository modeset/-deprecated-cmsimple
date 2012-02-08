module Cmsimple
  class PagesController < ApplicationController
    self.responder = Cmsimple::TemplateResponder
    respond_to :html

    def show
      @page = Page.find_by_path("/#{params[:page]}")
      respond_with @page
    end
  end
end
