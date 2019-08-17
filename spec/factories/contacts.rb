FactoryBot.define do
  factory :contact do
    association :owner

    name { Faker::Games::Dota.player }
    mobile { Faker::PhoneNumber.cell_phone  }
  end
end