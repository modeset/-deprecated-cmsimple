class AddMetaInfoToCmsimplePages < ActiveRecord::Migration
  def change
    change_table :cmsimple_pages do |t|
      t.string :keywords
      t.text   :description
      t.string :browser_title
    end
  end
end
