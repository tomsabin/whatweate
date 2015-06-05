class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :event_id
      t.integer :user_id
    end
  end
end
