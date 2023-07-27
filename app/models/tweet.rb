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
#
################ logic #################
# - the `processed` tag is used to determine if the stem has been created by the ai.
#   * it is set to true in tweets/make_stem_job.rb
#
# - the `invalid_json` tag is set to true if the ai fails to create a stem for the discussion.
#   * it is set to true in tweets/make_stem_job.rb
#
# - the `uploaded` tag is used to determine if the discussion has been uploaded to Ayrshare
#   * it is set to true in tweets/publish_tweet_job.rb
#
# - the `published_at` tag is the date when the item was published to Ayrshare
#   * it is set to true in tweets/publish_tweet_job.rb
#
# - the `approved` tag is set in the tweet controller and is used as a part of the scope to
#   determine tweets that need publishing.
########################################

class Tweet < ApplicationRecord
  belongs_to :discussion

  scope :needs_approval, -> { where(approved: nil, uploaded: false, invalid_json: false) }

  scope :approved_tweets, -> { where(approved: true) }

  scope :denied, -> { where(approved: false) }

  scope :published, -> { where(uploaded: true) }
end
