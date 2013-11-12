module Cmsimple
  class ImagesController < Cmsimple.configuration.parent_controller.constantize

    self.responder = Cmsimple::ApiResponder

    respond_to :json, :html
    layout 'panel'

    def index
      @images = Image.all
      respond_with @images
    end

    def new
      @image = Image.new
      respond_with @image
    end

    def create
      @image = Image.new(params[:image])
      @image.save
      respond_with @image, location: new_image_path
    end

    def destroy
      @image = Image.find(params[:id])
      @image.destroy
      respond_with @image
    end
  end
end
