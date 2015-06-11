class AddEventIndexes < ActiveRecord::Migration
  def change
    add_index :events, ["host_id"], name: "index_events_on_host_id", using: :btree
  end
end
