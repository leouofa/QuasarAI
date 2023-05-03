class Assignment < ApplicationRecord
  belongs_to :story, required: true
  belongs_to :feed_item, required: true

  validates :feed_item_id, uniqueness: { scope: :story_id }
end
