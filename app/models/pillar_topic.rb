# == Schema Information
#
# Table name: pillar_topics
#
#  id               :bigint           not null, primary key
#  title            :string
#  summary          :text
#  pillar_column_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  processed        :boolean          default(FALSE)
#
class PillarTopic < ApplicationRecord
  belongs_to :pillar_column

  validates :title, uniqueness: { scope: :pillar_column_id }
  validates :summary, uniqueness: { scope: :pillar_column_id }

  scope :processed, -> { where(processed: true) }
  scope :unprocessed, -> { where(processed: false) }
end
