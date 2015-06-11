class AddBookingIndexes < ActiveRecord::Migration
  def change
    add_index :bookings, ["event_id"], name: "index_bookings_on_event_id", using: :btree
    add_index :bookings, ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end
end
