# == Schema Information
#
# Table name: pillars
#
#  id         :bigint           not null, primary key
#  title      :string
#  columns    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Pillar < ApplicationRecord
  has_many :pillar_columns, dependent: :nullify
  validates :title, :columns, presence: true

  scope :with_less_columns, lambda {
    left_joins(:pillar_columns)
      .group('pillars.id')
      .having('COUNT(pillar_columns.id) < pillars.columns')
  }
end
