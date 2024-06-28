# == Schema Information
#
# Table name: pillar_columns
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  pillar_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  topics      :text
#
class PillarColumn < ApplicationRecord
  belongs_to :pillar
  has_many :articles

  serialize :topics

  validates_presence_of :name, :description

  scope :without_topics, -> { where(topics: nil) }
  scope :with_topics, -> { where.not(topics: nil) }
end
