class AddPrimaryPhotoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :primary_photo, :string
  end
end
