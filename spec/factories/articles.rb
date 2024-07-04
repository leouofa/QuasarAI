# == Schema Information
#
# Table name: articles
#
#  id               :bigint           not null, primary key
#  name             :string
#  description      :string
#  pillar_column_id :bigint           not null
#  original_text    :text
#  rewritten_text   :text
#  published_at     :datetime
#  rewritten_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  embedding        :vector(768)
#  invalid_json     :boolean          default(FALSE)
#
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
