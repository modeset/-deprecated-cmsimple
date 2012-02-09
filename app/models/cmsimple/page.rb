require 'ostruct'
module Cmsimple
  class Page < ActiveRecord::Base
    serialize :content, Hash
    validates :path,
              :content,
              :presence => true

    def regions
      OpenStruct.new self.content.inject({}) { |h, (k,v)| h[k] = v['value']; h}
    end

    def update_content(json)
      update_attributes(content: JSON.parse(json))
    end

  end
end
