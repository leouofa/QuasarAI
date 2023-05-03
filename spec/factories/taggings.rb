FactoryBot.define do
  factory :tagging do
    association :feed_item
    association :tag
  end
end
