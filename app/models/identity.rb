class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  scope :facebook, -> (user) { find_by(user: user, provider: 'facebook') }
  scope :twitter, -> (user) { find_by(user: user, provider: 'twitter') }

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
