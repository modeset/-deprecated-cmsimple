class CreateCmsimplePages < ActiveRecord::Migration
  def change
    create_table :cmsimple_pages do |t|
      t.string :path, :null => false
      t.string :template
      t.text :content
    end
    add_index :cmsimple_pages, :path
  end
end
