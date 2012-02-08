module Cmsimple
  class Page < ActiveRecord::Base
    validates :path,
              :content,
              :presence => true

    def template
      nil
    end

  end
end
