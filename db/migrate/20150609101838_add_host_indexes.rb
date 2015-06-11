class AddHostIndexes < ActiveRecord::Migration
  def change
    add_index :hosts, ["user_id"], name: "index_hosts_on_user_id", using: :btree
  end
end
