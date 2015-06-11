class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :booking, index: true, foreign_key: true
      t.string :customer_reference
      t.string :charge_reference
    end
  end
end
