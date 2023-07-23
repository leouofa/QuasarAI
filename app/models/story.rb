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
#

################ logic #################
# - the `processed` tag is used to determine if the stem has been created by the ai.
#  * it is set to true in stories/make_stem_job.rb
#  * if it checked against in the process_story_stems_job.rb
#
# - the `invalid_json` tag is set to true if the ai fails to create a stem for the story.
#  * it is set to true in stories/make_stem_job.rb
#
# - the `invalid_images` tag is set to true if the ai fails to create images ideas for any of the images.
#   * it is set to true in create_image_idea_job.rb
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

  scope :viewable, lambda {
                     where(processed: true,
                           invalid_json: false,
                           invalid_images: false)
                   }
  scope :unprocessed, -> { where(processed: false) }
  scope :processed, -> { where(processed: true) }

  scope :without_images, lambda {
    joins("LEFT JOIN images ON images.story_id = stories.id")
      .where("images.id IS NULL")
      .where(invalid_images: false, invalid_json: false)
  }

  scope :with_stem_and_valid_processed_images, lambda {
    joins(:images)
      .where(processed: true, invalid_json: false)
      .where(images: { processed: true, invalid_prompt: false, uploaded: true })
      .group('stories.id')
      .having('count(images.id) = 3')
  }

  scope :with_stem_and_valid_processed_images_no_discussions, lambda {
    with_stem_and_valid_processed_images
      .left_joins(:discussion)
      .where(discussions: { id: nil })
  }

  scope :unpublished_stories, lambda {
    joins(:discussion)
      .where(discussions: { uploaded: false, processed: true, invalid_json: false })
  }

  scope :published_stories, lambda {
    joins(:discussion)
      .where(discussions: { uploaded: true })
  }

  # seems like the stems with less then 1200 characters are spammy
  scope :spammy_stems, -> { where("LENGTH(stem) < ? AND invalid_json = ?", 1200, false) }
end
