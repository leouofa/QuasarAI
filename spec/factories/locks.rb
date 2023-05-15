# == Schema Information
#
# Table name: locks
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  locked     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :lock do
    sequence(:name) { |n| "Job#{n}" }
    locked { false }
  end
end
