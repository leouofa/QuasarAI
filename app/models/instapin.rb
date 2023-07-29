# == Schema Information
#
# Table name: instapins
#
#  id            :bigint           not null, primary key
#  discussion_id :bigint           not null
#  stem          :text
#  processed     :boolean          default(FALSE)
#  invalid_json  :boolean          default(FALSE)
#  uploaded      :boolean          default(FALSE)
#  approved      :boolean
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Instapin < ApplicationRecord
  belongs_to :discussion
end
