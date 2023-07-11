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
end
