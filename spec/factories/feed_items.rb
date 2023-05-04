FactoryBot.define do
  factory :feed_item do
    feed
    payload { { url: Faker::Internet.url, author: Faker::Name.name, crawled: Faker::Time.backward, published: Faker::Time.backward } }
    content { Faker::Lorem.paragraph }
    uuid { Faker::Internet.uuid }
    markdown_content { Faker::Markdown.emphasis }
    processed { false }
  end
end