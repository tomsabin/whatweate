FactoryGirl.define do
  factory :host do
    name { Faker::Name.name }
  end
end
