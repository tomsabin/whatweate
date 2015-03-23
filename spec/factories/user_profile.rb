FactoryGirl.define do
  factory :user_without_profile, class: User do
    email 'user@example.com'
    password 'letmein!!'
  end
end
