# == Schema Information
#
# Table name: discussions
#
#  id           :bigint           not null, primary key
#  stem         :text
#  processed    :boolean          default(FALSE)
#  invalid_json :boolean          default(FALSE)
#  uploaded     :boolean          default(FALSE)
#  story_id     :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#
FactoryBot.define do
  factory :discussion do
    story
    stem { "Some text" }
    processed { false }
    invalid_json { false }
    uploaded { false }
  end
end
