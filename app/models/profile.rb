class Profile < ActiveRecord::Base
  belongs_to :user

  validates :user, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true
end
