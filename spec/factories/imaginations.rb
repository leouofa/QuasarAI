# spec/factories/imaginations.rb

FactoryBot.define do
  factory :imagination do
    association :image
    aspect_ratio { Imagination.aspect_ratios.keys.sample }
    status { :pending }
    message_uuid { SecureRandom.uuid }
    payload { { 'test_payload_key': 'test_payload_value' } }
    uploaded { false }
    uploadcare { { 'test_uploadcare_key': 'test_uploadcare_value' } }

    trait :card do
      aspect_ratio { :card }
    end

    trait :landscape do
      aspect_ratio { :landscape }
    end

    trait :portrait do
      aspect_ratio { :portrait }
    end

    trait :pending do
      status { :pending }
    end

    trait :upscaling do
      status { :upscaling }
    end

    trait :success do
      status { :success }
    end

    trait :failure do
      status { :failure }
    end
  end
end
