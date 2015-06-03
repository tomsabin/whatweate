class Profile < ActiveRecord::Base
  belongs_to :user
  delegate :email, :first_name, :last_name, to: :user
  accepts_nested_attributes_for :user

  validates :user_id, :date_of_birth, :profession, :bio, :mobile_number, :favorite_cuisine, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
