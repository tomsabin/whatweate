class Profile < ActiveRecord::Base
  belongs_to :user
  delegate :email, :first_name, :last_name, to: :user
  accepts_nested_attributes_for :user

  validates :user, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true
end
