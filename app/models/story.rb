# == Schema Information
#
# Table name: stories
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_topic_id   :bigint           not null
#  stem           :text
#  processed      :boolean          default(FALSE)
#  invalid_json   :boolean          default(FALSE)
#  invalid_images :boolean          default(FALSE)
#  approved       :boolean
#

################ logic #################
# - the `processed` tag is used to determine if the stem has been created by the ai.
#  * it is set to true in stories/make_stem_job
#  * if it checked against in the process_story_stems_job
#
# - the `invalid_json` tag is set to true if the ai fails to create a stem for the story.
#  * it is set to true in stories/make_stem_job
#
# - the `invalid_images` tag is set to true if the ai fails to create images ideas for any of the images.
#   * it is set to true in create_image_idea_job
#
# - the `approved` is set if the tweet has been approved for publishing
#   * it is set to true or false in stories/moderate_story_job
########################################

class Story < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :feed_items, through: :assignments

  has_one :story_tag, dependent: :destroy
  has_one :tag, through: :story_tag

  has_many :images, dependent: :destroy
  has_many :imaginations, through: :images

  has_one :discussion, dependent: :destroy

  belongs_to :sub_topic

  # used by the `stories_controller` as a filter
  scope :viewable, lambda {
                     where(processed: true,
                           invalid_json: false,
                           invalid_images: false)
                   }

  # used as a filter on `processed_story_stems_job` and `update_settings_job`
  scope :unprocessed, -> { where(processed: false) }

  scope :processed, -> { where(processed: true) }

  # used by the `create_image_ideas_from_stories_job` to generate image ideas
  scope :without_images, lambda {
    joins("LEFT JOIN images ON images.story_id = stories.id")
      .where("images.id IS NULL")
      .where(approved: true, invalid_images: false, invalid_json: false)
  }

  # only used in this file to use as base for another filter
  scope :with_stem_and_valid_processed_images, lambda {
    joins(:images)
      .where(approved: true, processed: true, invalid_json: false)
      .where(images: { processed: true, invalid_prompt: false, uploaded: true })
      .group('stories.id')
      .having('count(images.id) = 3')
  }

  # used by the `process_discussion_stems_job` to create discussions
  # for stories with valid images.
  scope :with_stem_and_valid_processed_images_no_discussions, lambda {
    with_stem_and_valid_processed_images
      .left_joins(:discussion)
      .where(discussions: { id: nil })
  }

  # used by the filtering `stories_controller`, dashboard on `page_controller`
  # and  as a filter `moderate_stories_job`
  scope :needs_approval, lambda {
    where(approved: nil, invalid_json: false)
  }

  # used by the filtering `stories_controller` and dashboard on `page_controller`
  scope :denied_stories, lambda {
    where(approved: false, invalid_json: false)
  }

  # used by the filtering `stories_controller` and dashboard on `page_controller`
  scope :approved_stories, lambda {
    where(approved: true, invalid_json: false)
  }

  # used by the filtering `stories_controller`
  scope :published_stories, lambda {
    joins(:discussion)
      .where(invalid_json: false,
             discussions: { uploaded: true })
  }

  # seems like the stems with less then 1200 characters are spammy
  # it is used by the kill_spammy_stories_jobs.rb to kill off spammy looking stories
  scope :spammy_stems, -> { where("LENGTH(stem) < ? AND invalid_json = ?", 1200, false) }
end
