module Cmsimple
  class FrontController < Cmsimple.configuration.parent_front_controller.constantize
    self.responder = Cmsimple.configuration.template_strategy
    helper Cmsimple::RegionsHelper
    helper_method :in_editor_iframe?, :current_page

    before_filter :check_for_redirect, :only => [:show, :editor, :update_content]
    respond_to :html, :json, :js

    def show
      Cmsimple::PageResponder.new(self).respond
    end

    def in_editor_iframe?
      params[:mercury_frame] && (params[:mercury_frame] == true || params[:mercury_frame] == 'true')
    end

    def current_path
      @path ||= Path.from_request!(request)
    end

    def current_page
      @page ||= if params[:id].present?
                  Cmsimple::Page.find(params[:id])
                else
                  current_path.destination
                end
    end

    def check_for_redirect
      if current_path.redirect?
        path = current_path.destination.uri
        path = "/editor#{path}" if action_name == 'editor'
        redirect_to path, status: 301
      end
    end
  end
end
