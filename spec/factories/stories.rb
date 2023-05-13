# == Schema Information
#
# Table name: stories
#
#  id             :bigint           not null, primary key
#  payload        :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_topic_id   :bigint           not null
#  stem           :text
#  processed      :boolean          default(FALSE)
#  invalid_json   :boolean          default(FALSE)
#  invalid_images :boolean          default(FALSE)
#
FactoryBot.define do
  factory :story do
    sub_topic
    payload { { some_key: Faker::Lorem.word, another_key: Faker::Lorem.sentence } }
    processed { false }
  end
end
