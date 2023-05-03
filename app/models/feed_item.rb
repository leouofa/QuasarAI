# == Schema Information
#
# Table name: feed_items
#
#  id         :bigint           not null, primary key
#  feed_id    :bigint           not null
#  payload    :jsonb
#  content    :text
#  uuid       :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FeedItem < ApplicationRecord
  belongs_to :feed

  jsonb_accessor :payload,
                 url: :string,
                 author: :string,
                 crawled: :datetime,
                 published: :datetime
end
