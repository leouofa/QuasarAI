FactoryBot.define do
  factory :sub_topic do
    name { Faker::Lorem.word }
    topic
  end
end