module Cmsimple
  class PathsController < Cmsimple.configuration.parent_controller.constantize
    respond_to :json

    def index
      @paths = Path.all
      respond_with @paths
    end

    def create
      @path = Path.new(params[:path])
      @path.save
      respond_with @path
    end

    def destroy
      @path = Path.find(params[:id])
      @path.destroy
      respond_with @path
    end
  end
end

