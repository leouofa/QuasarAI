# == Schema Information
#
# Table name: assignments
#
#  id           :bigint           not null, primary key
#  story_id     :bigint           not null
#  feed_item_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null


################ LOGIC #################
# - Joins the `stories` and `feed_items` tables.
########################################

class Assignment < ApplicationRecord
  belongs_to :story, optional: false
  belongs_to :feed_item, optional: false

  validates :feed_item_id, uniqueness: { scope: :story_id }
end
