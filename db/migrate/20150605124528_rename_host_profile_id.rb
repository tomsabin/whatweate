class RenameHostProfileId < ActiveRecord::Migration
  def change
    rename_column :hosts, :profile_id, :user_id
  end
end
