class CreateCmsimplePath < ActiveRecord::Migration
  def change
    create_table :cmsimple_paths do |t|
      t.string :uri
      t.string :redirect_uri
      t.integer :page_id

      t.timestamps
    end
  end
end
