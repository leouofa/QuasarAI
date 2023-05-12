# == Schema Information
#
# Table name: story_tags
#
#  id         :bigint           not null, primary key
#  story_id   :bigint           not null
#  tag_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :story_tag do
    story
    tag
  end
end
