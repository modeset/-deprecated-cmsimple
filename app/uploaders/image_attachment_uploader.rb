# encoding: utf-8

class ImageAttachmentUploader < CarrierWave::Uploader::Base

  # Include detection for content types
  include CarrierWave::MimeTypes

  # Include RMagick or MiniMagick support:
  include Cmsimple.configuration.image_processor_mixin

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    eval '"' + Cmsimple.configuration.asset_path + '"'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  process :set_content_type
  process :store_geometry

  # Create different versions of your uploaded files:
  version :panel do
    process :resize_and_pad => [182, 182]
  end

  def store_geometry
    if @file
      model.width, model.height = Dimensions.dimensions(@file.file)
    end
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
