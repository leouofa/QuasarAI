# == Schema Information
#
# Table name: stories
#
#  id         :bigint           not null, primary key
#  prefix     :string
#  payload    :jsonb
#  complete   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :story do
    prefix { Faker::Lorem.word }
    payload { { some_key: Faker::Lorem.word, another_key: Faker::Lorem.sentence } }
    complete { false }
  end
end
