# == Schema Information
#
# Table name: tweets
#
#  id            :bigint           not null, primary key
#  discussion_id :bigint           not null
#  stem          :text
#  processed     :boolean          default(FALSE)
#  invalid_json  :boolean          default(FALSE)
#  uploaded      :boolean          default(FALSE)
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  approved      :boolean
#
FactoryBot.define do
  factory :tweet do
    association :discussion
    stem { Faker::Lorem.sentence(word_count: 10) }
    processed { false }
    invalid_json { false }
    uploaded { false }
    published_at { Faker::Time.backward(days: 14, period: :morning, format: :long) }
  end
end
