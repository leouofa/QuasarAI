FactoryBot.define do
  factory :pillar_column do
    sequence(:name) { |n| "Column Name #{n}" }
    description { "Sample description for the pillar column." }
    association :pillar
  end
end
