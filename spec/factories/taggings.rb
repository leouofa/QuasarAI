# == Schema Information
#
# Table name: taggings
#
#  id           :bigint           not null, primary key
#  feed_item_id :bigint           not null
#  tag_id       :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :tagging do
    feed_item
    tag
  end
end
