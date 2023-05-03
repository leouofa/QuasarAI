FactoryBot.define do
  factory :feed_item do
    association :feed
    url { Faker::Internet.url }
    crawled { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    published { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    content { Faker::Lorem.paragraph }
    markdown_content { Faker::Markdown.sandwich(sentences: 2) }
  end
end
