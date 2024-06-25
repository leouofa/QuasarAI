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
  has_many :pillar_columns

  validates_presence_of :title, :columns
end
