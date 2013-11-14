module Cmsimple
  class PathsController < Cmsimple.configuration.parent_controller.constantize

    self.responder = Cmsimple::ApiResponder

    respond_to :json

    def index
      @paths = Path.all
      respond_with @paths
    end

    def create
      @path = Path.new(path_params)
      @path.save!
      respond_with @path
    end

    def destroy
      @path = Path.find(params[:id])
      @path.destroy
      respond_with @path
    end

    private

    def path_params
      whitelisted = [:page_id, :uri, :redirect_uri]
      params.require(:path).permit(*whitelisted)
    end
  end
end

