module Cmsimple
  class PagesController < Cmsimple.configuration.parent_controller.constantize
    self.responder = Cmsimple.configuration.template_strategy
    helper Cmsimple::RegionsHelper

    respond_to :html, :json, :js

    def index
      @pages = Page.all
      respond_with @pages
    end

    def show
      @path = Path.from_request(request)
      if @path.redirect?
        redirect_to @path.destination.path
      else
        @page = @path.destination
        respond_with @page
      end
    end

    def update_content
      @page = Path.from_request(params[:page]).destination
      @page.update_content(params[:content])
      respond_with @page, :location => @page.path
    end

    def editor
      @path = Path.from_request(params[:page])
      if @path.redirect?
        redirect_to "/editor#{@path.destination.path}"
      else
        @page = @path.destination
        render :nothing => true, :layout => 'editor'
      end
    end

    def edit
      @page = Page.find(params[:id])
      render :edit, :layout => false
    end

    def new
      @page = Page.new
      render :new, :layout => false
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

  end
end
