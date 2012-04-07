class CreateCmsimpleImages < ActiveRecord::Migration
  def change
    create_table :cmsimple_images do |t|
      t.string :attachment
      t.string :width
      t.string :height
      t.string :file_size
      t.string :content_type
      t.string :title
      t.timestamps
    end
  end
end
