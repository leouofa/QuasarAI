FactoryBot.define do
  factory :tweet do
    association :discussion
    stem { Faker::Lorem.sentence(word_count: 10) }
    processed { false }
    invalid_json { false }
    uploaded { false }
    published_at { Faker::Time.backward(days: 14, period: :morning, format: :long) }
  end
end
