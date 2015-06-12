class AddPhotosToEvents < ActiveRecord::Migration
  def change
    add_column :events, :photos, :json
  end
end
