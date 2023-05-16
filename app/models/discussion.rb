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
#  story_pro_id :integer
#
class Discussion < ApplicationRecord
  belongs_to :story
  has_one :tweet, dependent: :destroy

  scope :ready_to_upload, lambda {
                            joins(story: :sub_topic)
                              .where(processed: true, invalid_json: false, uploaded: false)
                          }
  scope :published_today_and_uploaded, lambda {
                                         joins(story: :sub_topic)
                                           .where(uploaded: true,
                                                  published_at: Time.now.utc.beginning_of_day..Time.now.utc.end_of_day)
                                       }

  scope :ready_for_tweets, lambda {
    joins(story: :sub_topic)
      .where(processed: true, invalid_json: false)
      .left_outer_joins(:tweet)
      .where(tweets: { discussion_id: nil })
  }
end
