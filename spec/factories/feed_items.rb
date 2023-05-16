# == Schema Information
#
# Table name: feed_items
#
#  id               :bigint           not null, primary key
#  feed_id          :bigint           not null
#  payload          :jsonb
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  uuid             :string
#  markdown_content :text
#  processed        :boolean          default(FALSE)
#
FactoryBot.define do
  factory :feed_item do
    feed
    payload do
      { url: Faker::Internet.url, author: Faker::Name.name, crawled: Faker::Time.backward, published: Faker::Time.backward }
    end
    content { Faker::Lorem.paragraph }
    created_at { Faker::Time.between(from: 30.days.ago, to: Time.zone.today) }
    updated_at { created_at }
    uuid { Faker::Internet.uuid }
    markdown_content { Faker::Markdown.emphasis }
    processed { false }
  end
end
