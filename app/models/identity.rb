class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.facebook(user)
    find_by(user: user, provider: "facebook")
  end

  def self.twitter(user)
    find_by(user: user, provider: "twitter")
  end

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
