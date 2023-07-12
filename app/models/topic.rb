# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Topic < ApplicationRecord
  has_many :sub_topics, dependent: :destroy

  def active_subtopics
    sub_topics.active
  end

  scope :with_active_subtopic, lambda {
    joins(:sub_topics).where(sub_topics: { active: true }).distinct
  }
end
