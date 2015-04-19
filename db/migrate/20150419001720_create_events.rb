class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :host_id
      t.string :title
      t.string :location
      t.text :description
      t.text :menu
      t.integer :seats
      t.integer :price_in_pennies
      t.string :currency

      t.timestamps
    end
  end
end
