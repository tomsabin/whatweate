FactoryGirl.define do
  factory :user_from_omniauth_without_profile, class: User do
    state    "omniauth_complete"
    password { Faker::Internet.password }

    to_create { |instance| instance.save(validate: false) }

    trait :facebook do
      email      { Faker::Internet.email }
      first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name }

      after :create do |user|
        FactoryGirl.create(:facebook_identity, user: user)
      end
    end

    trait :twitter do
      after :create do |user|
        FactoryGirl.create(:twitter_identity, user: user)
      end
    end

    factory :user_from_omniauth_with_profile do
      state            "profile_complete"
      email            { Faker::Internet.email }
      first_name       { Faker::Name.first_name }
      last_name        { Faker::Name.last_name }
      date_of_birth    { Faker::Date.between(16.years.ago, 100.years.ago) }
      profession       { Faker::Company.catch_phrase }
      bio              { Faker::Lorem.paragraph }
      mobile_number    { Faker::PhoneNumber.phone_number }
      favorite_cuisine { Faker::Lorem.word }
      greeting         { Faker::Lorem.sentence }

      after :create do |user|
        FactoryGirl.create(:twitter_identity, user: user)
      end
    end
  end
end
