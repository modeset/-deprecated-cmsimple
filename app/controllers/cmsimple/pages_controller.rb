module Cmsimple
  class PagesController < Cmsimple.configuration.parent_controller.constantize
    helper_method :current_page

    before_filter :check_for_redirect, :only => [:editor, :update_content]
    respond_to :html, :json, :js

    def index
      @pages = Page.all
      respond_with @pages
    end

    def show
      @page = Page.find(params[:id])
      respond_with @page
    end

    def update_content
      current_page.update_content(params[:content])
      respond_with @page, :location => @page.uri
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

    def destroy
      @page = Page.find(params[:id])
      @page.destroy
      respond_with(@page) do |format|
        format.html{ redirect_to '/editor' }
      end
    end

    #helpers
    def current_path
      @path ||= Path.from_request!(request)
    end

    def current_page
      @page ||= current_path.destination
    end

    def check_for_redirect
      return true if params[:id].present?
      if current_path.redirect?
        path = current_path.destination.uri
        path = "/editor#{path}" if action_name == 'editor'
        redirect_to path, status: 301
      end
    end

  end
end
