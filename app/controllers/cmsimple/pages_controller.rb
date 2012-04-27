module Cmsimple
  class PagesController < Cmsimple.configuration.parent_controller.constantize
    self.responder = Cmsimple.configuration.template_strategy
    helper Cmsimple::RegionsHelper
    helper_method :in_editor_iframe?

    respond_to :html, :json, :js

    before_filter :find_page_from_request, only: [:show, :update_content, :editor]

    def index
      @pages = Page.all
      respond_with @pages
    end

    def show
      if current_page_is_viewable?
        respond_with @page
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def update_content
      @page.update_content(params[:content])
      respond_with @page, :location => @page.path
    end

    def editor
      render :nothing => true, :layout => 'editor'
    end

    def edit
      @page = Page.find(params[:id])
      render :edit, :layout => false
    end

    def new
      @page = Page.new
      render :new, :layout => false
    end

    def publish
      @page = Page.find(params[:id])
      render :publish, :layout => false
    end

    def update
      @page = Page.find(params[:id])
      params[:page].delete :id if params[:page] && params[:page].key?(:id)
      if @page.update_attributes(params[:page])
        respond_with(@page)
      else
        render :edit, layout: false, status: 422
      end
    end

    def create
      params[:page].delete :id if params[:page] && params[:page].key?(:id)
      @page = Page.new(params[:page])
      if @page.save
        respond_with(@page)
      else
        render :new, layout: false, status: 422
      end
    end

    protected
    def in_editor_iframe?
      params[:mercury_frame] && (params[:mercury_frame] == true || params[:mercury_frame] == 'true')
    end

    def current_page_is_viewable?
      in_editor_iframe? || @page.published?
    end

    def find_page_from_request
      @path = Path.from_request(params[:page])
      if @path.redirect?
        path = @path.destination.path
        path = "/editor#{path}" if action_name == 'editor'
        redirect_to path, status: 301
      else
        @page = @path.destination
      end
    end

  end
end
