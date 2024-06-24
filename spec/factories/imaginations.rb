# == Schema Information
#
# Table name: imaginations
#
#  id                 :bigint           not null, primary key
#  aspect_ratio       :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  payload            :jsonb            not null
#  status             :integer          default("pending"), not null
#  message_uuid       :uuid             not null
#  image_id           :bigint
#  uploaded           :boolean          default(FALSE), not null
#  uploadcare         :jsonb
#  upscaled_image_url :string
#

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
