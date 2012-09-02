class RenamePathToCurrentUriOnPaths < ActiveRecord::Migration
  def change
    rename_column :cmsimple_pages, :path, :uri
  end
end
