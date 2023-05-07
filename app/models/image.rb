# == Schema Information
#
# Table name: images
#
#  id           :bigint           not null, primary key
#  story_id     :bigint           not null
#  idea         :text
#  uploaded_url :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Image < ApplicationRecord
  belongs_to :story
end
