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
class Tagging < ApplicationRecord
  belongs_to :feed_item, optional: false
  belongs_to :tag, optional: false
  validates :tag_id, uniqueness: { scope: :feed_item_id }
end
