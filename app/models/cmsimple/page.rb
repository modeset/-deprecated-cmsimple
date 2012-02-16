require 'ostruct'
module Cmsimple
  class Page < ActiveRecord::Base
    serialize :content, Hash
    validates :path,
              :presence => true

    def regions
      @regions ||= RegionsProxy.new(self.content)
    end

    def update_content(content)
      update_attributes(content: content)
    end

  end
end
