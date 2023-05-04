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
class Assignment < ApplicationRecord
  belongs_to :story, required: true
  belongs_to :feed_item, required: true

  validates :feed_item_id, uniqueness: { scope: :story_id }
end
