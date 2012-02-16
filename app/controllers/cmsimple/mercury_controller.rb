module Cmsimple
  class MercuryController < ::MercuryController
    def resource
      render :action => "/#{params[:type]}/#{params[:resource]}"
    end
  end
end
