class RemoveUserUniqueEmailIndex < ActiveRecord::Migration
  def change
    remove_index :users, name: 'index_users_on_email', column: :email
  end
end
