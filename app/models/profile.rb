class Profile < ActiveRecord::Base
  belongs_to :user
  delegate :email, :first_name, :last_name, to: :user

  validates :user, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true
end
