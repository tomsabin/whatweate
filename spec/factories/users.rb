FactoryGirl.define do
  factory :user_without_profile, class: User do
    email      { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    password   { Faker::Internet.password }

    factory :user_with_profile do
      after :create do |user|
        user.update({
          date_of_birth:    Faker::Date.between(16.years.ago, 100.years.ago),
          profession:       Faker::Company.catch_phrase,
          bio:              Faker::Lorem.paragraph,
          mobile_number:    Faker::PhoneNumber.phone_number,
          favorite_cuisine: Faker::Lorem.word,
          greeting:         Faker::Lorem.sentence
        })
      end
    end

    factory :user do
      date_of_birth    { Faker::Date.between(16.years.ago, 100.years.ago) }
      profession       { Faker::Company.catch_phrase }
      bio              { Faker::Lorem.paragraph }
      mobile_number    { Faker::PhoneNumber.phone_number }
      favorite_cuisine { Faker::Lorem.word }
      greeting         { Faker::Lorem.sentence }
    end

    trait :authorised_with_facebook do
      after :create do |user|
        FactoryGirl.create(:facebook_identity, user: user)
      end
    end
  end
end
