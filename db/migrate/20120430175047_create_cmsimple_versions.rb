class CreateCmsimpleVersions < ActiveRecord::Migration
  def up
    create_table :cmsimple_versions do |t|
      t.text     :content
      t.string   :template
      t.datetime :published_at
      t.integer  :page_id
      t.timestamps
    end
    add_index :cmsimple_versions, :page_id
    add_index :cmsimple_versions, :published_at
  end
end
