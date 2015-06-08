class AddSlugToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :slug, :string
    add_index :hosts, :slug, unique: true
  end
end
