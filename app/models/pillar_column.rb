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
#  processed   :boolean          default(FALSE)

################ LOGIC #################
# - The `processed` value is set to true once the pillar column has been parsed and the feed items have been created.
#   * This ensures that the column only gets processed once.
#   * The value is set by the create_pillar_topics_job.rb job.
########################################

class PillarColumn < ApplicationRecord
  belongs_to :pillar
  has_many :articles
  has_many :pillar_topics

  serialize :topics

  validates_presence_of :name, :description

  scope :without_topics, -> { where(topics: nil) }
  scope :with_topics, -> { where.not(topics: nil) }
  scope :unprocessed, -> { where(processed: false) }
end
