module Cmsimple
  class PagesController < Cmsimple.configuration.parent_controller.constantize

    self.responder = Cmsimple::ApiResponder

    respond_to :html, :json, :js

    helper_method :current_page

    before_filter :check_for_redirect, only: [:editor, :update_content]
    before_filter :find_page, only: [:show, :edit, :publish, :update, :destroy]


    def index
      @pages = Page.all
      respond_with @pages
    end

    def show
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
      render :edit, :layout => false
    end

    def new
      @page = Page.new
      render :new, :layout => false
    end

    def publish
      render :publish, :layout => false
    end

    def update
      if @page.update_attributes!(page_params)
        render json: @page
      else
        render :edit, layout: false, status: 422
      end
    end

    def create
      @page = Page.new(page_params)
      if @page.save
        render json: @page
      else
        render :new, layout: false, status: 422
      end
    end

    def destroy
      @page.destroy
      respond_with(@page) do |format|
        format.html{ redirect_to '/editor' }
      end
    end

    private

    def find_page
      @page = Page.find(params[:id])
    end

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

    def page_params
      return permitted_page_params if respond_to?(:permitted_page_params, true)
      whitelisted = [:title, :slug, :template, :parent_id, :is_root, :browser_title, :keywords, :description, :commit, :uri, :position, :published]
      params.require(:page).permit(*whitelisted)
    end

  end
end
