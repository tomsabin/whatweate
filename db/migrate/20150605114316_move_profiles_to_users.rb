class MoveProfilesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :date_of_birth, :date
    add_column :users, :profession, :string
    add_column :users, :greeting, :string
    add_column :users, :bio, :text
    add_column :users, :mobile_number, :string
    add_column :users, :favorite_cuisine, :string
    add_column :users, :date_of_birth_visible, :boolean, default: false
    add_column :users, :mobile_number_visible, :boolean, default: false

    execute <<-SQL

      UPDATE users u
      SET date_of_birth = p.date_of_birth,
          profession = p.profession,
          greeting = p.greeting,
          bio = p.bio,
          mobile_number = p.mobile_number,
          favorite_cuisine = p.favorite_cuisine,
          date_of_birth_visible = p.date_of_birth_visible,
          mobile_number_visible = p.mobile_number_visible
      FROM profiles p
      WHERE u.id = p.user_id

    SQL

    remove_column :profiles, :date_of_birth
    remove_column :profiles, :profession
    remove_column :profiles, :greeting
    remove_column :profiles, :bio
    remove_column :profiles, :mobile_number
    remove_column :profiles, :favorite_cuisine
    remove_column :profiles, :date_of_birth_visible
    remove_column :profiles, :mobile_number_visible
  end

  def self.down
    add_column :profiles, :date_of_birth, :date
    add_column :profiles, :profession, :string
    add_column :profiles, :greeting, :string
    add_column :profiles, :bio, :text
    add_column :profiles, :mobile_number, :string
    add_column :profiles, :favorite_cuisine, :string
    add_column :profiles, :date_of_birth_visible, :boolean, default: false
    add_column :profiles, :mobile_number_visible, :boolean, default: false

    execute <<-SQL

      UPDATE profiles p
      SET date_of_birth = u.date_of_birth,
          profession = u.profession,
          greeting = u.greeting,
          bio = u.bio,
          mobile_number = u.mobile_number,
          favorite_cuisine = u.favorite_cuisine,
          date_of_birth_visible = u.date_of_birth_visible,
          mobile_number_visible = u.mobile_number_visible
      FROM users u
      WHERE p.user_id = u.id

    SQL

    remove_column :users, :date_of_birth
    remove_column :users, :profession
    remove_column :users, :greeting
    remove_column :users, :bio
    remove_column :users, :mobile_number
    remove_column :users, :favorite_cuisine
    remove_column :users, :date_of_birth_visible
    remove_column :users, :mobile_number_visible
  end
end
