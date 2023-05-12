# == Schema Information
#
# Table name: feed_items
#
#  id               :bigint           not null, primary key
#  feed_id          :bigint           not null
#  payload          :jsonb
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  uuid             :string
#  markdown_content :text
#  processed        :boolean          default(FALSE)


################ LOGIC #################
# - The `uuid` value is from feedly and prevents duplicate feed items from being created.
#
# - The `processed` column is set to true once it has been assigned to a story.
#   * This ensures that the feed item is only assigned to one story.
#   * The value is set by the create_stories_job.rb job.
#
# - The `markdown_content` column is populated by the convert_html_to_markdown_job.rb job.
#   * It is performed on all the feed items that have a nil value for the markdown_content column.
########################################


class FeedItem < ApplicationRecord
  belongs_to :feed

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_one :assignment, dependent: :destroy
  has_one :story, through: :assignment

  jsonb_accessor :payload,
                 title: :string,
                 url: :string,
                 author: :string,
                 crawled: :datetime,
                 published: :datetime

  scope :processed, -> { where(processed: true) }

end
