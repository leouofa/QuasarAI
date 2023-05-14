# == Schema Information
#
# Table name: discussions
#
#  id           :bigint           not null, primary key
#  stem         :text
#  processed    :boolean          default(FALSE)
#  invalid_json :boolean          default(FALSE)
#  uploaded     :boolean          default(FALSE)
#  story_id     :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#
class Discussion < ApplicationRecord
  belongs_to :story
end
