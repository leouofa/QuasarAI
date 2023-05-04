FactoryBot.define do
  factory :story do
    prefix { Faker::Lorem.word }
    payload { { some_key: Faker::Lorem.word, another_key: Faker::Lorem.sentence } }
    complete { false }
  end
end
