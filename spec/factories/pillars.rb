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
FactoryBot.define do
  factory :pillar do
    title { "Sample Title" }
    columns { 20 }
  end
end
