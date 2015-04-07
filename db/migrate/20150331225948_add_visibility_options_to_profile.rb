class AddVisibilityOptionsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :date_of_birth_visible, :boolean, default: false
    add_column :profiles, :mobile_number_visible, :boolean, default: false
  end
end
