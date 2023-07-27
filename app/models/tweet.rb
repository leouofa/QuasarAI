# == Schema Information
#
# Table name: tweets
#
#  id            :bigint           not null, primary key
#  discussion_id :bigint           not null
#  stem          :text
#  processed     :boolean          default(FALSE)
#  invalid_json  :boolean          default(FALSE)
#  uploaded      :boolean          default(FALSE)
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  approved      :boolean
#

class Tweet < ApplicationRecord
  belongs_to :discussion

  scope :needs_approval, -> { where(approved: nil, uploaded: false, invalid_json: false) }

  scope :approved_tweets, -> { where(approved: true) }

  scope :denied, -> { where(approved: false) }

  scope :published, -> { where(uploaded: true) }
end
