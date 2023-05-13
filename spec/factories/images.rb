# spec/factories/images.rb

FactoryBot.define do
  factory :image do
    association :story
    idea { "An AI-generated idea #{Faker::Lorem.sentence(word_count: 5)}" }
    invalid_prompt { false }
    processed { false }

    trait :processed do
      processed { true }
    end

    trait :invalid_prompt do
      invalid_prompt { true }
    end
  end
end