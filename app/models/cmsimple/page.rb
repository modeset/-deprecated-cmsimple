module Cmsimple
  class Page < ActiveRecord::Base
    validates :path,
              :content,
              :presence => true
  end
end
