FactoryBot.define do
  factory :lock do
    sequence(:name) { |n| "Job#{n}" }
    locked { false }
  end
end
