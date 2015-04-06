class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :profile, dependent: :destroy

  validates :email, :first_name, :last_name, presence: true

  def self.find_for_oauth(auth, signed_in_resource = nil)
    OmniauthUser.find(auth, signed_in_resource)
  end
end
