# == Schema Information
#
# Table name: pillar_columns
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  pillar_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PillarColumn < ApplicationRecord
  belongs_to :pillar

  validates_presence_of :name, :description
end
