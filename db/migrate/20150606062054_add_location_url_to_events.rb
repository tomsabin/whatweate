class AddLocationUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location_url, :string
  end
end
