FactoryGirl.define do
  factory :facebook_identity, class: Identity do
    provider "facebook"
    uid "123456"
  end

  factory :twitter_identity, class: Identity do
    provider "twitter"
    uid "123456"
  end
end
