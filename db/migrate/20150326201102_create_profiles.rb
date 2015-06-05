class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.date :date_of_birth
      t.string :profession
      t.string :greeting
      t.text :bio
      t.string :mobile_number
      t.string :favorite_cuisine
      t.timestamps
    end
  end
end
