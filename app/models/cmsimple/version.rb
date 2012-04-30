module Cmsimple
  class Version < ActiveRecord::Base
    serialize :content, Hash

    attr_accessible :content,
                    :template,
                    :published_at

    belongs_to :page, class_name: '::Cmsimple::Page'

    validates :published_at, presence: true

  end
end
