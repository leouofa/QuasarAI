# == Schema Information
#
# Table name: sub_topics
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  topic_id             :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  stream_id            :string
#  min_tags_for_story   :integer
#  storypro_category_id :integer
#  storypro_user_id     :integer
#  prompts              :string
#  max_stories_per_day  :integer
#
FactoryBot.define do
  factory :sub_topic do
    name { Faker::Lorem.word }
    prompts { 'default' }
    topic
  end
end
