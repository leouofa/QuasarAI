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
#  error        :boolean          default(FALSE)
#

################ LOGIC #################
# - The `processed` value is set to true once the feed has been parsed and the feed items have been created.
#   * This ensures that the feed only gets processed once.
#   * The value is set by the create_feed_items_job.rb job.
#
# - The `payload` column is a JSONB column that contains the raw feed data.
#   * It is populated via an API Call performed by the create_feeds_job.rb job.
########################################


class Feed < ApplicationRecord
  belongs_to :sub_topic

  has_many :feed_items, dependent: :destroy
  validates :sub_topic_id, presence: true

  scope :viewable, -> { where(processed: true).where.not(error: true) }
  scope :unprocessed, -> { where(processed: false).where.not(error: true) }


  paginates_per 5
end
