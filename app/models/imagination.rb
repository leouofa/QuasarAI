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
#
class Imagination < ApplicationRecord
  belongs_to :image

  enum status: { pending: 0, upscaling: 1, success: 2, failure: 3 }

  ## Card (Used for Social Media)
  # 2048 x 1024
  # AR 2:1

  ## Landscape
  # Resolution 2560 x 1456
  # AR 1.76:1 – almost 16:9

  ## Portrait
  # Resolution 1456 x 2560
  # AR 1.76:1 – almost 9:16
  enum aspect_ratio: { card: 0, landscape: 1, portrait: 2 }
end
