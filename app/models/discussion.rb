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

################ logic #################
# - the `processed` tag is used to determine if the stem has been created by the ai.
#   * it is set to true in discussions/make_stem_job.rb
#   * if it checked against in the process_discussion_stems_job.rb
#
# - the `invalid_json` tag is set to true if the ai fails to create a stem for the discussion.
#   * it is set to true in discussions/make_stem_job.rb
#
# - the `uploaded` tag is used to determine if the discussion has been uploaded to StoryPRO
# * it is set to true in create_discussion_job.rb
#
# - the `published_at` tag is the date when the item was published to StoryPRO
#   * it is set to true in create_discussion_job.rb
#
# - the `story_pro_id` is the id of the discussion in StoryPRO
#   * it is set to true in create_discussion_job.rb
########################################

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

  scope :ready_to_make_tweets, lambda {
    joins(story: :sub_topic)
      .where(processed: true, invalid_json: false)
      .left_outer_joins(:tweet)
      .where(tweets: { discussion_id: nil })
  }

  scope :ready_to_upload_tweets, lambda {
    joins(story: :sub_topic)
      .where(uploaded: true)
      .joins(:tweet)
      .where(tweets: { uploaded: false, invalid_json: false, approved: true })
  }

  scope :published, -> { where(uploaded: true) }
  scope :unpublished, -> { ready_to_upload }
end
