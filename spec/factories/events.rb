FactoryGirl.define do
  factory :event do
    association       :host
    state             "available"
    date              { rand(5..20).days.from_now }
    title             { Faker::Company.catch_phrase }
    location          { Faker::Address.city }
    location_url      { Faker::Internet.url("example.com") }
    description       { Faker::Lorem.paragraph }
    short_description { Faker::Lorem.sentence.truncate(80) }
    menu              { Faker::Lorem.paragraph }
    seats             { rand(5..20) }
    price_in_pennies  { rand(500..5000) }
    currency          "GBP"

    trait :sold_out do
      state "sold_out"
      seats 1

      after(:create) do |event|
        Booking.create(event: event, user: FactoryGirl.create(:user))
      end
    end

    trait :pending do
      state "pending"
    end

    trait :with_primary_photo do
      primary_photo { File.open(Rails.root.join("fixtures", "carrierwave", "image.png")) }
    end

    trait :with_photos do
      photos do
        [ File.open(Rails.root.join("fixtures", "carrierwave", "image.png")),
          File.open(Rails.root.join("fixtures", "carrierwave", "image-1.png")) ]
      end
    end
  end
end
