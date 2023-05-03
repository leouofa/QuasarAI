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
#
class FeedItem < ApplicationRecord
  belongs_to :feed

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  jsonb_accessor :payload,
                 url: :string,
                 author: :string,
                 crawled: :datetime,
                 published: :datetime
end
