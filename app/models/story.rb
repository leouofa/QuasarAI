# == Schema Information
#
# Table name: stories
#
#  id         :bigint           not null, primary key
#  prefix     :string
#  payload    :jsonb
#  complete   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Story < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :feed_items, through: :assignments

  has_one :story_tag, dependent: :destroy
  has_one :tag, through: :story_tag
end
