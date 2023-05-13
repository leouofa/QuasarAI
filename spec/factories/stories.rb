# == Schema Information
#
# Table name: stories
#
#  id             :bigint           not null, primary key
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
    processed { false }

    after(:create) do |story|
      create(:story_tag, story:, tag: create(:tag))
    end
  end
end
