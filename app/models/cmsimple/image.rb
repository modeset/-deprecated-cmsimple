module Cmsimple
  class Image < ActiveRecord::Base
    mount_uploader :attachment, ImageAttachmentUploader

    validates :attachment, :presence => true
  end
end
