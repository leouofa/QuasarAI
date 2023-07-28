# == Schema Information
#
# Table name: tweets
#
#  id            :bigint           not null, primary key
#  discussion_id :bigint           not null
#  stem          :text
#  processed     :boolean          default(FALSE)
#  invalid_json  :boolean          default(FALSE)
#  uploaded      :boolean          default(FALSE)
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  approved      :boolean

################ logic #################
# - the `processed` tag is used to determine if the stem has been created by the ai.
#   * it is set to true in tweets/make_stem_job.rb
#
# - the `invalid_json` tag is set to true if the ai fails to create a stem for the discussion.
#   * it is set to true in tweets/make_stem_job.rb
#
# - the `uploaded` tag is used to determine if the discussion has been uploaded to StoryPRO
# * it is set to true in publish_tweet_job.rb
#
# - the `published_at` tag is the date when the item was published to StoryPRO
#   * it is set to true in publish_tweet_job.rb
#
# - the `approved` is set if the tweet has been approved for publishing
#   * it is set to true or false in tweets_controller.rb
########################################

class Tweet < ApplicationRecord
  belongs_to :discussion

  # used by `tweets_controller` for filtering and `page_controller` for dashboard logic
  scope :needs_approval, -> { where(approved: nil, uploaded: false) }

  # used by `tweets_controller` for filtering and `page_controller` for dashboard logic
  scope :approved_tweets, -> { where(approved: true) }

  # used by `tweets_controller` for filtering and `page_controller` for dashboard logic
  scope :denied, -> { where(approved: false) }

  # used by `tweets_controller` for filtering and `page_controller` for dashboard logic
  scope :published, -> { where(uploaded: true) }
end
