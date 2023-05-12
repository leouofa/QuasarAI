# == Schema Information
#
# Table name: stories
#
#  id             :bigint           not null, primary key
#  payload        :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_topic_id   :bigint           not null
#  stem           :text
#  processed      :boolean          default(FALSE)
#  invalid_json   :boolean          default(FALSE)
#  invalid_images :boolean          default(FALSE)
#

################ LOGIC #################
# - The `processed` tag is used to determine if the stem has been created by the AI.
#  * It is set to true in make_stem_job.rb
#  * If it checked against in the process_stories_job.rb
#
# - The `invalid_json` tag is set to true if the AI fails to create a stem for the story.
#  * It is set to true in make_stem_job.rb
#
# - The `invalid_images` tag is set to true if the AI fails to create images ideas for ANY of the images.
#   * It is set to true in create_image_idea_job.rb
########################################

class Story < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :feed_items, through: :assignments

  has_one :story_tag, dependent: :destroy
  has_one :tag, through: :story_tag

  has_many :images, dependent: :destroy
  has_many :imaginations, through: :images

  belongs_to :sub_topic

  scope :unprocessed, -> { where(processed: false ) }
  scope :processed, -> { where(processed: true) }

  scope :with_stem_and_valid_processed_images, lambda {
    joins(:images)
      .where(processed: true, invalid_json: false)
      .where(images: { processed: true, invalid_prompt: false })
      .group('stories.id')
      .having('count(images.id) = 3')
  }
end
