module Cmsimple
  class VersionsController < Cmsimple.configuration.parent_controller.constantize
    respond_to :json

    def index
      @versions = Page.find(params[:page_id]).versions
      respond_with @versions
    end

    def revert_to
      @page = Page.find(params[:page_id])
      @version = @page.versions.find(params[:id])
      @page.revert_to!(@version)
      respond_with @page
    end
  end
end
