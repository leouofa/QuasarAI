FactoryBot.define do
  factory :feed do
    sub_topic
    payload { { some_key: Faker::Lorem.word, another_key: Faker::Lorem.sentence } }
    processed { false }
  end
end
