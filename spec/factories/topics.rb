FactoryBot.define do
  factory :topic do
    name { Faker::Lorem.word }
  end
end