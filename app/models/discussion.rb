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
  has_one :instapin, dependent: :destroy

  # used by the `discussions/publish_job` to filter discussions ready to be published
  scope :ready_to_upload, lambda {
                            joins(story: :sub_topic)
                              .where(processed: true, invalid_json: false, uploaded: false)
                              .joins(:tweet).where(tweets: { approved: true })
                          }

  # used by the `discussions/publish_job` to filter discussions published today
  scope :published_today_and_uploaded, lambda {
                                         joins(story: :sub_topic)
                                           .where(uploaded: true,
                                                  published_at: Time.now.utc.beginning_of_day..Time.now.utc.end_of_day)
                                       }

  # used by the `tweets/process_twitter_stems_job` to make stems for tweets
  scope :ready_to_make_tweets, lambda {
    joins(story: :sub_topic)
      .where(processed: true, invalid_json: false)
      .left_outer_joins(:tweet)
      .where(tweets: { discussion_id: nil })
  }

  # used by the `tweets/publish_job` to decide which tweets are ready to be published
  scope :ready_to_upload_tweets, lambda {
    joins(story: :sub_topic)
      .where(uploaded: true)
      .joins(:tweet)
      .where(tweets: { uploaded: false, invalid_json: false, approved: true })
  }

  # used by the `instapins/process_instapin_stems_job` to decide which instapins are ready to be created
  scope :ready_to_create_instapins, lambda {
    joins(story: :sub_topic)
      .where(uploaded: true, sub_topics: { active: true })
      .joins(:tweet)
      .where(tweets: { uploaded: true, invalid_json: false, approved: true })
      .left_outer_joins(:instapin)
      .where(instapins: { discussion_id: nil})
  }

  # used by the `instapins/publish_instapin_job` to decide which tweets are ready to be published
  scope :ready_to_upload_instapins, lambda {
    joins(story: :sub_topic)
      .where(uploaded: true)
      .joins(:instapin)
      .where(instapins: { uploaded: false, invalid_json: false, approved: true })
  }

  # used by `discussions_controller` for filtering
  scope :valid_discussions, -> { where(invalid_json: false) }

  # used by `discussions_controller` for filtering and `page_controller` for dashboard logic
  scope :published, -> { where(uploaded: true, invalid_json: false) }

  # used by `discussions_controller` for filtering and `page_controller` for dashboard logic
  scope :unpublished, -> { ready_to_upload }

  def parsed_stem
    return false if invalid_json

    JSON.parse(stem)
  end
end
