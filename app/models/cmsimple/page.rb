require 'ostruct'
module Cmsimple
  class Page < ActiveRecord::Base
    serialize :content, Hash
    validates :path,
              :presence => true

    def regions
      @regions ||= RegionProxy.new(self.content)
    end

    def update_content(json)
      update_attributes(content: JSON.parse(json))
    end

  end
end
