class AddIsRootToPage < ActiveRecord::Migration
  def change
    add_column :cmsimple_pages, :is_root, :boolean, default: false
  end
end
