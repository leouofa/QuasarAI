# == Schema Information
#
# Table name: sub_topics
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  topic_id             :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  stream_id            :string
#  min_tags_for_story   :integer
#  storypro_category_id :integer
#  storypro_user_id     :integer

#TODO:
#   have stream_id, min_tags_for_story, storypro_category_id,
#   storypro_user_id be pulled form YML file directly

class SubTopic < ApplicationRecord
  belongs_to :topic
  has_many :feeds, dependent: :destroy
  has_many :stories, dependent: :destroy
end
