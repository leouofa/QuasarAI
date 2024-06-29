# == Schema Information
#
# Table name: pillar_topics
#
#  id               :bigint           not null, primary key
#  title            :string
#  summary          :text
#  pillar_column_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  processed        :boolean          default(FALSE)
#
FactoryBot.define do
  factory :pillar_topic do
    sequence(:title) { |n| "Topic Title #{n}" }
    sequence(:summary) { |n| "Sample summary for the pillar topic #{n}." }
    processed { false }
    association :pillar_column
  end
end
