# == Schema Information
#
# Table name: stories
#
#  id             :bigint           not null, primary key
#  prefix         :string
#  payload        :jsonb
#  complete       :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_topic_id   :bigint           not null
#  stem           :text
#  processed      :boolean          default(FALSE)
#  invalid_json   :boolean          default(FALSE)
#  invalid_images :boolean          default(FALSE)

################ LOGIC #################
# - The `processed` tag is set to true once the image has had 3 imaginations created for it.
#   * If creating the imaginations fails, the `invalid_prompt` column is set to true.
#   * The logic for this is in imagine_image_job.rb
########################################

class Story < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :feed_items, through: :assignments

  has_one :story_tag, dependent: :destroy
  has_one :tag, through: :story_tag

  has_many :images, dependent: :destroy
  has_many :imaginations, through: :images

  belongs_to :sub_topic
end
