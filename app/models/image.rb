# == Schema Information
#
# Table name: images
#
#  id             :bigint           not null, primary key
#  story_id       :bigint           not null
#  idea           :text
#  uploaded_url   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  invalid_prompt :boolean          default(FALSE)
#
class Image < ApplicationRecord
  belongs_to :story
  has_many :imaginations

  def card_imagination
    imaginations.where(aspect_ratio: :card).last
  end
end
