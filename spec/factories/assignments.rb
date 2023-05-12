# == Schema Information
#
# Table name: assignments
#
#  id           :bigint           not null, primary key
#  story_id     :bigint           not null
#  feed_item_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :assignment do
    story
    feed_item
  end
end
