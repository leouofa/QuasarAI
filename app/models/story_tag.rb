class StoryTag < ApplicationRecord
  belongs_to :story, required: true
  belongs_to :tag, required: true
  validates :tag_id, uniqueness: { scope: :story_id }
end
