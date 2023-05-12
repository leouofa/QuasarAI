# == Schema Information
#
# Table name: images
#
#  id             :bigint           not null, primary key
#  story_id       :bigint           not null
#  idea           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  invalid_prompt :boolean          default(FALSE)
#  processed      :boolean          default(FALSE), not null


################ LOGIC #################
# - Each image contains an `idea` column that is populated by the AI in create_image_idea_job.rb.
#
# - The `processed` tag is set to true once the image has had 3 imaginations created for it.
#   * If creating the imaginations fails, the `invalid_prompt` column is set to true.
#   * The logic for setting `processed` and `invalid_prompt` is imagine_image_job.rb
#   * The imagine_images_job.rb uses those variables to determine if it should create imaginations for the image.
########################################


class Image < ApplicationRecord
  belongs_to :story
  has_many :imaginations, dependent: :destroy

  scope :processed_and_valid, -> { where(processed: true, invalid_prompt: false) }


  def card_imagination
    imaginations.where(aspect_ratio: :card).last
  end

  def landscape_imagination
    imaginations.where(aspect_ratio: :landscape).last
  end

  def portrait_imagination
    imaginations.where(aspect_ratio: :portrait).last
  end
end
