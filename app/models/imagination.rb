# == Schema Information
#
# Table name: imaginations
#
#  id           :bigint           not null, primary key
#  aspect_ratio :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  payload      :jsonb            not null
#  status       :integer          default("pending"), not null
#  message_uuid :uuid             not null
#  image_id     :bigint
#  uploaded     :boolean          default(FALSE), not null
#  uploadcare   :jsonb
#

################ LOGIC #################
# - Each imagination has a `status` that is originally set as `pending` by the imagine_image_job.rb job.
#   * The status is the then updated by the midjourney_controller.rb as the image is processed.
#   * The `failure` tag is not currently being used
#
# - `message_uuid` is the uuid of the message that was sent to the Midjourney.
#   * It is originally set it in the imagine_image_job.rb job.
#   * It is used to reference and update the status of the imagination by the midjourney_controller.rb
#
# - `payload` is contains the response from the Midjourney (as proxied by NextLeg API)
#   * It is originally set it in the imagine_image_job.rb job.
#   * It is updated by the midjourney_controller.rb as the image is processed.
#   * It contains the `image_url` that is used by upload_imaginations_job.rb.
#
# - `uploaded` is a boolean that is set to true once the imagination has been uploaded to Uploadcare.
#   * It is set to true by the upload_imaginations_job.rb job.
#   * It is used as upload filtering criteria (along w/ `status`) by the upload_imaginations_job.rb.
#
# - `uploadcare` is a contains the response from Uploadcare.
#   * It is set by the upload_imaginations_job.rb job.
#
# - There are 3 different aspect ratios.
#   * Card (Used for Social Media) – 2048 x 1024 – AR 2:1
#   * Landscape – 2560 x 1456 – AR 1.76:1 (almost 16:9)
#   * Portrait – Resolution 1456 x 2560 – AR 0.57:1 (almost 9:16)
########################################


class Imagination < ApplicationRecord
  belongs_to :image

  enum status: { pending: 0, upscaling: 1, success: 2, failure: 3 }
  enum aspect_ratio: { card: 0, landscape: 1, portrait: 2 }

  scope :successful_unuploaded, -> { where(status: :success, uploaded: false) }
end
