FactoryBot.define do
  factory :contact do
    association :owner

    name { Faker::StarWars.character }
    mobile { Faker::PhoneNumber.cell_phone  }
  end
end