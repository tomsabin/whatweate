FactoryGirl.define do
  factory :event do
    association      :host
    date             { rand(5..20).days.from_now }
    title            { Faker::Company.catch_phrase }
    location         { Faker::Address.city }
    location_url     { Faker::Internet.url("example.com") }
    description      { Faker::Lorem.paragraph }
    menu             { Faker::Lorem.paragraph }
    seats            { rand(5..20) }
    price_in_pennies { rand(500..5000) }
    currency         "GBP"

    trait :sold_out do
      state "sold_out"
      seats 1

      after(:create) do |event|
        Booking.create(event: event, user: FactoryGirl.create(:user))
      end
    end
  end
end
