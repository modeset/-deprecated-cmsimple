class AddTimestampsToCmsimplePages < ActiveRecord::Migration
  def change
    change_table :cmsimple_pages do |t|
      t.timestamps
    end
  end
end
