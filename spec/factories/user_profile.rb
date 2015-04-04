FactoryGirl.define do
  factory :user_without_profile, class: User do
    email      { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    password   { Faker::Internet.password }

    factory :user_with_profile, aliases: [:user] do
      after :build do |user, _|
        user.profile = FactoryGirl.build(:profile, user: user)
      end
    end
  end

  factory :profile do
    date_of_birth    { Faker::Date.between(16.years.ago, 100.years.ago) }
    profession       { Faker::Company.catch_phrase }
    bio              { Faker::Lorem.paragraph }
    mobile_number    { Faker::PhoneNumber.phone_number }
    favorite_cuisine { Faker::Lorem.word }
    greeting         { Faker::Lorem.sentence }
    association :user, factory: :user_without_profile
  end
end
