class AddSlugToPages < ActiveRecord::Migration
  def change
    change_table :cmsimple_pages do |t|
      t.string :slug
    end
  end
end
