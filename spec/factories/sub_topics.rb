# == Schema Information
#
# Table name: sub_topics
#
#  id                 :bigint           not null, primary key
#  name               :string
#  topic_id           :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  stream_id          :string
#  min_tags_for_story :integer
#
FactoryBot.define do
  factory :sub_topic do
    name { Faker::Lorem.word }
    topic
  end
end
