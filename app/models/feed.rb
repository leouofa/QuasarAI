# == Schema Information
#
# Table name: feeds
#
#  id           :bigint           not null, primary key
#  sub_topic_id :bigint           not null
#  payload      :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  processed    :boolean          default(FALSE)
#
class Feed < ApplicationRecord
  belongs_to :sub_topic
end
