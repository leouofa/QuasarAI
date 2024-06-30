FactoryBot.define do
  factory :article do
    association :pillar_column
    sequence(:name) { |n| "Sample Article #{n}" }
    description { "This is a sample article." }
    original_text { "Some original text." }
  end

  factory :article_link do
    association :article
    association :linked_article, factory: :article
  end
end
