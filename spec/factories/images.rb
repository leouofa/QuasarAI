# == Schema Information
#
# Table name: images
#
#  id             :bigint           not null, primary key
#  story_id       :bigint           not null
#  idea           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  invalid_prompt :boolean          default(FALSE)
#  processed      :boolean          default(FALSE), not null
#  uploaded       :boolean          default(FALSE)
#

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
