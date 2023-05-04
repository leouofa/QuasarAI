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
class StoryTag < ApplicationRecord
  belongs_to :story, required: true
  belongs_to :tag, required: true
  validates :tag_id, uniqueness: { scope: :story_id }
end
