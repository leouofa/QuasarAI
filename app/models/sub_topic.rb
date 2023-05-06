# == Schema Information
#
# Table name: sub_topics
#
#  id                 :bigint           not null, primary key
#  name               :string
#  topic_id           :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  stream_id          :string
#  min_tags_for_story :integer
#
class SubTopic < ApplicationRecord
  belongs_to :topic
  has_many :feeds, dependent: :destroy
  has_many :stories, dependent: :destroy
end
